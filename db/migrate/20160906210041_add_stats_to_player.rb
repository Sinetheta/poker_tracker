class AddStatsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :winner, :boolean
    add_column :players, :round_out, :integer
    add_column :players, :position_out, :integer
  end
end
