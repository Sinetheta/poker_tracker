class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :iid_id
      t.belongs_to :category, index: true

      t.timestamps null: false
    end
  end
end
