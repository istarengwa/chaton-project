class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_user.cart
    @cart_items = @cart.cart_items.includes(:item)
    @total_price = @cart_items.sum { |ci| ci.item.price }
  end
end