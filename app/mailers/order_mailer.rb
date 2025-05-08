class OrderMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]

  def confirmation_email(order)
    @order = order
    @user = order.user
    @items = order.items
    mail(to: @user.email, subject: "Merci pour ta commande de chatons !")
  end
end
  
