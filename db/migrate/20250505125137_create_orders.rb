class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.integer :total_cents
      t.string :stripe_payment_id

      t.timestamps
    end
  end
end
