class RemoveGuestUserGuestsTables < ActiveRecord::Migration
  def change
    drop_table :games_guests
    drop_table :games_users
  end
end
