class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
    @orders = current_user.orders.includes(order_items: :item)
  end
end
  