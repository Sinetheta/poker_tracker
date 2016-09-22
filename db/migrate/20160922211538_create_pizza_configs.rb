class CreatePizzaConfigs < ActiveRecord::Migration
  def change
    create_table :pizza_configs do |t|
      t.belongs_to :user, index: true
      t.string :webpage_path
      t.string :menu_path
      t.string :item_path
      t.string :checkout_path
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.string :ordernote
      t.string :address
      t.string :company
      t.string :buzzer
      t.string :city
      t.string :postal_code
      t.string :payment_method

      t.timestamps null: false
    end
  end
end
