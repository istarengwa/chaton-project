class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[ show edit update destroy ]

  # GET /cart_items or /cart_items.json
  def index
    @cart_items = CartItem.all
  end

  # GET /cart_items/1 or /cart_items/1.json
  def show
  end

  # GET /cart_items/new
  def new
    @cart_item = CartItem.new
  end

  # GET /cart_items/1/edit
  def edit
  end

  # POST /cart_items or /cart_items.json
  # def create
  #   @cart_item = CartItem.new(cart_item_params)

  #   respond_to do |format|
  #     if @cart_item.save
  #       format.html { redirect_to @cart_item, notice: "Cart item was successfully created." }
  #       format.json { render :show, status: :created, location: @cart_item }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @cart_item.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  def create
    cart = current_user.cart
    item = Item.find(params[:item_id])

    if cart.items.include?(item)
      redirect_to cart_path, alert: "Ce chaton est déjà dans ton panier."
    else
      cart.cart_items.create!(item: item)
      redirect_to cart_path, notice: "Chaton ajouté au panier !"
    end
  end

  # PATCH/PUT /cart_items/1 or /cart_items/1.json
  def update
    respond_to do |format|
      if @cart_item.update(cart_item_params)
        format.html { redirect_to @cart_item, notice: "Cart item was successfully updated." }
        format.json { render :show, status: :ok, location: @cart_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cart_items/1 or /cart_items/1.json
  # def destroy
  #   @cart_item.destroy!

  #   respond_to do |format|
  #     format.html { redirect_to cart_items_path, status: :see_other, notice: "Cart item was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end
  def destroy
    cart_item = CartItem.find(params[:id])
    cart = cart_item.cart
    cart_item.destroy
  
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.remove(cart_item), # supprime la carte de l’item
          turbo_stream.replace("cart_total", partial: "carts/total", locals: { cart: cart })
        ]
      }
      format.html { redirect_to cart_path, notice: "Chaton retiré du panier." }
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart_item
      @cart_item = CartItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cart_item_params
      params.expect(cart_item: [ :cart_id, :item_id ])
    end
end
