require 'spec_helper'

RSpec.describe VendingMachine::Machine do
  let(:starting_coins)    { { '£2' => 5, '£1' => 5 } }
  let(:mars)              { VendingMachine::Product.new(name: 'Mars', price: 50) }
  let(:snickers)          { VendingMachine::Product.new(name: 'Snickers', price: 75) }
  let(:starting_products) { { mars => 5, snickers => 5 } }

  subject { described_class.new }

  context 'upon initialize' do
    it 'has a coin holder' do
      expect(subject.coin_bag).to be_empty
    end

    it 'has an empty product shelf' do
      expect(subject.product_shelf).to be_empty
    end

    it 'can be initialized with coins' do
      machine = described_class.new(coins: starting_coins)
      expect(machine.coin_bag.total_value).to eq(1500)
    end

    it 'can be initialized with products' do
      machine = described_class.new(products: starting_products)
      expect(machine.product_shelf.total_number_of_products).to eq(10)
    end
  end

  context 'loading the contents' do
    it 'can be loaded with change' do
      subject.add_coins('£2' => 5, '£1' => 5, '10p' => 3)
      expect(subject.coin_bag.total_value).to eq(1530)
    end

    it 'can be loaded with products' do
      subject.add_products(starting_products)
      expect(subject.product_shelf.total_number_of_products).to eq(10)
    end
  end

  context 'buying a product' do
    context 'when the product is unavailable' do
      it 'will raise an out of stock error' do
        expect { subject.select_product('Wine Gums') }.to raise_error(VendingMachine::ProductShelf::OutOfStockError)
      end
    end

    context 'when the product is available, but there is not enough change' do
      it 'will raise a not enough change error' do
        subject.add_products(starting_products)

        subject.select_product('Mars')
        subject.insert_coins('£1' => 1)

        expect { subject.vend }.to raise_error(VendingMachine::CoinBag::NotEnoughChangeError)
      end
    end

    context 'when the product is available and there is enough change' do
      it 'will sell you the product and return your change' do
        subject.add_products(starting_products)
        subject.add_coins('10p' => 5)

        expect(subject.coin_bag.total_value).to eq(50)

        subject.select_product('Mars')
        subject.insert_coins('£1' => 1)

        change, product = subject.vend

        expect(change).to eq('10p' => 5)
        expect(product.name).to eq('Mars')
        expect(subject.coin_bag.total_value).to eq(100)
      end
    end

    context 'when the product is available and you insert the exact value' do
      it 'will just vend the product' do
        subject.add_products(starting_products)

        subject.select_product('Mars')
        subject.insert_coins('50p' => 1)

        change, product = subject.vend

        expect(change).to eq({})
        expect(product.name).to eq('Mars')
      end

      context 'when you have not inserted enough money' do
        it 'will raise an error' do
          subject.add_products(starting_products)

          subject.select_product('Mars')
          subject.insert_coins('10p' => 1)

          expect { subject.vend }.to raise_error(VendingMachine::Machine::NotEnoughMoneyError)
        end
      end

      context 'when you have not selected a product' do
        it 'will raise an error' do
          subject.add_products(starting_products)

          subject.insert_coins('10p' => 1)

          expect { subject.vend }.to raise_error(VendingMachine::Machine::NoProductSelected)
        end
      end
    end
  end
end
