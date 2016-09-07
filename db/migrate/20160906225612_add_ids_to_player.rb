class AddIdsToPlayer < ActiveRecord::Migration
  def change
    add_reference :players, :user, index: true
    add_reference :players, :guest, index: true
  end
end
