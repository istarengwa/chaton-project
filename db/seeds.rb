# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

puts "🧹 Suppression des anciens items..."
Item.destroy_all

puts "📸 Création de 20 nouveaux chatons..."
20.times do
  Item.create!(
    title: Faker::Creature::Cat.name,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    price: Faker::Commerce.price(range: 5.0..25.0),
    image_url: "https://placecats.com/400/300?random=#{rand(1..1000)}"
  )
end

puts "✅ Seed terminée avec succès."
