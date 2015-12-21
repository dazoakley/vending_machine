require 'spec_helper'

RSpec.describe VendingMachine::Product do
  let(:name)  { 'Snickers' }
  let(:price) { 50 }

  subject { described_class.new(name: 'Snickers', price: 50) }

  context 'on setup' do
    it 'has a name' do
      expect(subject.name).to eq('Snickers')
    end

    it 'has a price' do
      expect(subject.price).to eq(50)
    end
  end

  context 'attributes can be updated' do
    it 'can have its name updated' do
      subject.name = 'Mars'
      expect(subject.name).to eq('Mars')
    end

    it 'can have its price updated' do
      subject.price = 75
      expect(subject.price).to eq(75)
    end
  end
end
