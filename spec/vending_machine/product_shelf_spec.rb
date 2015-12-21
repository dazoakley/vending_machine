require 'spec_helper'

RSpec.describe VendingMachine::ProductShelf do
  let(:mars)     { VendingMachine::Product.new(name: 'Mars', price: 0.50) }
  let(:snickers) { VendingMachine::Product.new(name: 'Snickers', price: 0.50) }

  subject { described_class.new }

  context 'when initialized' do
    it 'is empty' do
      expect(subject).to be_empty
    end
  end

  context 'adding and removing products' do
    before do
      subject.add_products(mars => 2, snickers => 3)
    end

    it 'can accept products' do
      expect(subject).to_not be_empty
    end

    it 'can release products' do
      subject.release_product('Mars')
      expect(subject.products).to eq(mars => 1, snickers => 3)
    end

    it 'only releases products it has' do
      expect { subject.release_product('Wine Gums') }.to raise_error(VendingMachine::ProductShelf::OutOfStockError, 'Wine Gums not in stock')
    end
  end
end
