module VendingMachine
  class CoinBag
    NotEnoughChangeError = Class.new(StandardError)

    COIN_VALUE = { '1p' => 1, '2p' => 2, '5p' => 5, '10p' => 10, '20p' => 20, '50p' => 50, '£1' => 100, '£2' => 200 }

    def initialize
      @coins  = { '1p' => 0, '2p' => 0, '5p' => 0, '10p' => 0, '20p' => 0, '50p' => 0, '£1' => 0, '£2' => 0 }
      @change = {}
    end

    attr_reader :coins

    def empty?
      total_value == 0
    end

    def total_value
      coins.map { |type, quantity| COIN_VALUE[type] * quantity }.reduce(:+)
    end

    def add_coins(coin_addition)
      coins.each do |type, _count|
        addition = coin_addition[type] || 0
        coins[type] += addition
      end
    end

    def release_coins(coin_request)
      coin_request.each { |type, quantity| release(type, quantity) }
    end

    def issue_change(amount_left)
      @change = {}

      COIN_VALUE.reverse_each do |coin_type, coin_value|
        next if amount_left < coin_value
        amount_left = process_change_coin(amount_left, coin_type, coin_value)
      end

      @change.each { |type, quantity| @change.delete(type) if quantity == 0 }

      if amount_left < 1
        release_coins(@change)
        return @change
      else
        fail NotEnoughChangeError, 'Not enough change'
      end
    end

    private

    def enough_left?(total, quantity)
      (total - quantity) >= 0
    end

    def release(type, quantity)
      fail NotEnoughChangeError, "Not enough #{type} coins" unless enough_left?(coins[type], quantity)
      reduce_total(type, quantity)
    end

    def reduce_total(type, quantity)
      coins[type] -= quantity
    end

    def process_change_coin(amount, type, value)
      if not_enoungh_of_one_coin?(amount, type, value)
        @change.merge!(type => coins[type])
        amount -= coins[type] * value
      else
        @change.merge!(type => number_of_coins_in(amount, value))
        amount % value
      end
    end

    def not_enoungh_of_one_coin?(amount, type, value)
      (amount / value).floor > coins[type]
    end

    def number_of_coins_in(amount, value)
      (amount / value).floor
    end
  end
end
