class AddDefaultBlindToGame < ActiveRecord::Migration
  def change
    change_column :games, :blinds, :text, :default => [1].to_yaml
  end
end
