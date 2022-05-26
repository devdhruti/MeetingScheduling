class CreatePaymentCards < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_cards do |t|
      t.string :stripe_id
      t.string :card_brand
      t.string :card_exp_month
      t.string :card_exp_year
      t.string :card_last4
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
