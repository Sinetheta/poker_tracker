class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  belongs_to :guest

  validate :guest_or_user

  scope :wins, -> { where(winner:true) }

  def owner
    if self.user
      self.user
    elsif self.guest
      self.guest
    end
  end

  def go_out
    self.round_out = self.game.round
    self.position_out = self.game.players_out.length
    self.winner = false
    self.save()
  end

  private

  def guest_or_user
    unless guest.nil? ^ user.nil?
      errors.add(:guest_or_user, "Must belong to either a guest or a user")
    end
  end

end
