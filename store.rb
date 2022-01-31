require "bigdecimal"

module Store
  class StoreItem
    def initialize(name:, unit_price:, sale_price: nil, sale_quantity: nil)
      @name = name
      @unit_price = unit_price
      @sale_price = sale_price
      @sale_quantity = sale_quantity
    end

    def name
      @name
    end

    def get_cost(purchased_quantity)
      if @sale_quantity.nil?
        (purchased_quantity * @unit_price).round(2)
      else
        ((purchased_quantity / @sale_quantity).floor * @sale_price).round(2) + ((purchased_quantity % @sale_quantity) * @unit_price).round(2)
      end
    end

    def get_savings(purchased_quantity)
      (purchased_quantity * @unit_price).round(2) - get_cost(purchased_quantity)
    end
  end

  class Store
    def initialize
      @items = [
        StoreItem.new({ name: 'milk', unit_price: BigDecimal("3.97"), sale_price: BigDecimal("5.00"), sale_quantity: 2 }),
        StoreItem.new({ name: 'bread', unit_price: BigDecimal("2.17"), sale_price: BigDecimal("6.00"), sale_quantity: 3 }),
        StoreItem.new({ name: 'banana', unit_price: BigDecimal("0.99") }),
        StoreItem.new({ name: 'apple', unit_price: BigDecimal("0.89") })
      ]
    end

    def checkout(item_names)
      # item_tab = { 'name': [StoreItem, quantity] }
      item_tab = {}
      item_names.each do |item_name|
        store_item = get_store_item_by_name(item_name)
        # can't find the item in store, skip it
        if store_item.nil?
          next
        end

        if item_tab[item_name].nil?
          item_tab[item_name] = [store_item, 1]
        else
          item_tab[item_name][1] += 1
        end
      end

      print_receipt(item_tab.values)
    end

    private 

    def get_store_item_by_name(name)
      @items.find{ |item| item.name == name }
    end

    def format_money(decimal)
      "$#{(decimal.to_s('F') + "00")[ /.*\..{2}/ ]}"
    end

    def print_table_line(arr)
      col_width = 20
      puts arr.reduce('') { |line, element| line + element.to_s.ljust(col_width) }
    end

    def print_receipt(line_items)
      puts
      print_table_line(['Item', 'Quantity', 'Price'])
      puts '----------------------------------------------------------'

      total_cost = BigDecimal("0.0")
      total_savings = BigDecimal("0.0")

      line_items.each do |line_item|
        store_item, quantity = line_item

        cost = store_item.get_cost(quantity)
        total_cost += cost

        savings = store_item.get_savings(quantity)
        total_savings += savings

        print_table_line([store_item.name.capitalize, quantity, format_money(cost)])
      end 

      puts
      puts "Total price : #{format_money(total_cost)}"
      puts "You saved #{format_money(total_savings)} today."
    end
  end
end
