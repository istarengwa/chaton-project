class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = current_user.orders.includes(:order_items)
  end

  # GET /orders/1 or /orders/1.json
  def show
    @order = current_user.orders.find(params[:id])
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  def create_checkout
    cart = current_user.cart
    if cart.cart_items.empty?
      redirect_to cart_path, alert: "Ton panier est vide."
      return
    end
  
    total = cart.cart_items.sum { |ci| ci.item.price }
  
    # Création de la commande
    order = current_user.orders.create!(
      status: "en_attente",
      total_cents: (total * 100).to_i
    )
  
    cart.cart_items.each do |cart_item|
      order.order_items.create!(item: cart_item.item)
    end
  
    # On vide le panier AVANT paiement (tu peux inverser si besoin)
    cart.cart_items.destroy_all
  
    # Création de la session Stripe
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: order.order_items.map do |order_item|
        item = order_item.item
        {
          price_data: {
            currency: 'eur',
            product_data: {
              name: item.title,
              description: item.description,
              images: [item.image_url]
            },
            unit_amount: (item.price * 100).to_i
          },
          quantity: 1
        }
      end,
      mode: 'payment',
      success_url: orders_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: orders_cancel_url
    )
  
    order.update(stripe_payment_id: session.payment_intent)
  
    redirect_to session.url, allow_other_host: true
  end
  
  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    payment_intent = Stripe::PaymentIntent.retrieve(session.payment_intent)
  
    # Optionnel : tu peux stocker le payment_intent.id dans l’ordre
    order = current_user.orders.order(created_at: :desc).first
    order.update(status: "paid", stripe_payment_id: payment_intent.id)

    # Envoi de l'email de confirmation
    OrderMailer.confirmation_email(order).deliver_later
  
    redirect_to cart_path(status: "paid")
  end  
  

  # POST /orders or /orders.json
  def create
    cart = current_user.cart
    if cart.cart_items.empty?
      redirect_to cart_path, alert: "Ton panier est vide !"
      return
    end

    total = cart.cart_items.sum { |ci| ci.item.price }

    # Création de la commande
    order = current_user.orders.create!(
      status: "en_attente",
      total_cents: (total * 100).to_i # stocké en centimes
    )

    # Ajout des items à la commande
    cart.cart_items.each do |cart_item|
      order.order_items.create!(item: cart_item.item)
    end

    # Vidage du panier
    cart.cart_items.destroy_all

    redirect_to order_path(order), notice: "Commande enregistrée avec succès !"
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, status: :see_other, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.expect(order: [ :user_id, :status, :total_cents, :stripe_payment_id ])
    end
end
