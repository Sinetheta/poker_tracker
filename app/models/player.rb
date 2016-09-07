class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  belongs_to :guest

  scope :out_in_game, ->(game) { where(winner: false, game_id: game.id) }
  scope :wins, -> { where(winner:true) }

  def owner
    if self.user
      self.user
    elsif self.guest
      self.guest
    end
  end
end
