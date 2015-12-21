require 'spec_helper'

RSpec.describe VendingMachine::CoinBag do
  subject { described_class.new }

  context 'when initialized' do
    it 'is empty' do
      expect(subject).to be_empty
    end

    it 'has a hopper for each type of coin' do
      expect(subject.coins).to eq('1p' => 0, '2p' => 0, '5p' => 0, '10p' => 0, '20p' => 0, '50p' => 0, '£1' => 0, '£2' => 0)
    end
  end

  context 'adding and removing coins' do
    before do
      subject.add_coins('£1' => 2, '50p' => 3)
    end

    it 'can accept coins' do
      expect(subject).to_not be_empty
    end

    it 'can calculate the value of the coins' do
      expect(subject.total_value).to eq(350)
    end

    it 'can release coins' do
      expect(subject.total_value).to eq(350)
      subject.release_coins('£1' => 1, '50p' => 1)
      expect(subject.total_value).to eq(200)
    end

    it 'only releases coins it has' do
      expect { subject.release_coins('1p' => 20) }.to raise_error(VendingMachine::CoinBag::NotEnoughChangeError, 'Not enough 1p coins')
    end
  end

  describe '#issue_change' do
    before do
      subject.add_coins('£1' => 1, '20p' => 5, '5p' => 1)
    end

    context 'when there is enough change' do
      it 'calculates the coins to use' do
        expect(subject.issue_change(45)).to eq('20p' => 2, '5p' => 1)
      end

      it 'removes the change from the coin bag' do
        subject.issue_change(45)
        expect(subject.coins).to eq('1p' => 0, '2p' => 0, '5p' => 0, '10p' => 0, '20p' => 3, '50p' => 0, '£1' => 1, '£2' => 0)
      end
    end

    context 'when there is not enough change' do
      it 'raises an error' do
        expect { subject.issue_change(150) }.to raise_error(VendingMachine::CoinBag::NotEnoughChangeError, 'Not enough change')
      end
    end
  end
end
