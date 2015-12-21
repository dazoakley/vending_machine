module VendingMachine
  class Machine
    NotEnoughMoneyError = Class.new(StandardError)
    NoProductSelected   = Class.new(StandardError)

    attr_reader :coin_bag, :product_shelf

    def initialize(coins: {}, products: {})
      @coin_bag      = CoinBag.new
      @product_shelf = ProductShelf.new

      add_coins(coins)
      add_products(products)

      reset_coins_inserted
      reset_selected_product
    end

    # Maintenance

    def add_coins(coins)
      coin_bag.add_coins(coins)
    end

    def release_coins(coins)
      coin_bag.release_coins(coins)
    end

    def add_products(products)
      product_shelf.add_products(products)
    end

    # User interaction

    def products_in_stock
      product_shelf.list
    end

    def select_product(product)
      @selected_product = product_shelf.release_product(product)
    end

    def insert_coins(coins)
      @coins_inserted.add_coins(coins)
    end

    def amount_inserted
      @coins_inserted.total_value
    end

    def vend
      fail NoProductSelected, 'Please select a product' unless @selected_product

      if amount_inserted > @selected_product.price
        [vend_change, vend_selected_product]
      elsif amount_inserted == @selected_product.price
        [{}, vend_selected_product]
      elsif amount_inserted < @selected_product.price
        fail NotEnoughMoneyError, 'Please insert more coins'
      end
    end

    private

    def reset_coins_inserted
      @coins_inserted = CoinBag.new
    end

    def reset_selected_product
      @selected_product = nil
    end

    def vend_selected_product
      product = @selected_product.dup
      reset_selected_product
      take_payment
      product
    end

    def take_payment
      @coin_bag.add_coins(@coins_inserted.coins)
      reset_coins_inserted
    end

    def vend_change
      amount = amount_inserted - @selected_product.price
      @coin_bag.issue_change(amount)
    end
  end
end
