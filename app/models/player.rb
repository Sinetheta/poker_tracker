class Player < ActiveRecord::Base
  belongs_to :game
  has_one :user
  has_one :guest

  scope :out_in_game, ->(game) { where(winner: false, game_id: game.id) }

  def owner
    if self.user
      self.user
    elsif self.guest
      self.guest
    end
  end
end
