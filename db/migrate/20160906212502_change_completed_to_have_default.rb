class ChangeCompletedToHaveDefault < ActiveRecord::Migration
  def change
    change_column :games, :complete, :boolean, :default => false
  end
end
