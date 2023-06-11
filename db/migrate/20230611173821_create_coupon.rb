class CreateCoupon < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code, unique: true
      t.integer :status, default: 0
      t.integer :discount_type, default: 0
      t.float :discount_value
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
    add_index :coupons, :name
    add_index :coupons, :code
  end
end
