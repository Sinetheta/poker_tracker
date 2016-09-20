class ChangeiidIdtoiidIt < ActiveRecord::Migration
  def change
    change_column :products, :iid_id, :iid_it
  end
end
