class RemoveIdsFromPlayer < ActiveRecord::Migration
  def change
    remove_column :players, :user_id
    remove_column :players, :guest_id
  end
end
