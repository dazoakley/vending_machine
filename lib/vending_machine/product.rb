module VendingMachine
  class Product
    attr_accessor :name, :price

    def initialize(name: '', price: 0.00)
      @name  = name
      @price = price
    end
  end
end
