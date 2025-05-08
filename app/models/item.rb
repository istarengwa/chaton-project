class Item < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  has_one_attached :image


  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validate :image_format

  private

  def image_format
    return unless image.attached?

    if !image.content_type.in?(%w[image/jpeg image/png])
      errors.add(:image, "doit être au format JPG ou PNG")
    end
  end
end
