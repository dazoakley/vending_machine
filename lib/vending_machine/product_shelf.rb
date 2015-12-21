module VendingMachine
  class ProductShelf
    OutOfStockError = Class.new(StandardError)

    def initialize(products: {})
      @products = products
    end

    attr_reader :products

    def add_products(new_products)
      products.merge!(new_products) do |_key, oldval, newval|
        oldval += newval
      end
    end

    def release_product(name)
      prod = products.keys.find { |product| product.name == name }

      fail OutOfStockError, "#{name} not in stock" unless prod

      release(prod, 1)
    end

    def empty?
      products.empty?
    end

    def total_number_of_products
      products.values.reduce(:+)
    end

    def list
      products.map(&:name).uniq
    end

    private

    def enough_left?(total, quantity)
      return false unless total
      (total - quantity) >= 0
    end

    def release(type, quantity)
      fail OutOfStockError, "#{name} not in stock" unless enough_left?(products[type], quantity)
      reduce_total(type, quantity)
      type
    end

    def reduce_total(type, quantity)
      products[type] -= quantity
    end
  end
end
