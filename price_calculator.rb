require './store.rb'

include Store

store = Store::Store.new

p 'Please enter all the items purchased separated by a comma'
cart_item_str = gets.chomp

cart_items = cart_item_str.split(',').map{ |item| item.strip }

store.checkout(cart_items)