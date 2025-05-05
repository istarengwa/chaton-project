class Item < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :order_items
  has_many :orders, through: :order_items


  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :image_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "doit être une URL valide" }
end
