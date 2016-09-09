class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  belongs_to :guest

  validate :guest_or_user
  validates :game_id, presence: true

  scope :wins, -> { where(winner:true) }

  def owner
    if self.user
      self.user
    elsif self.guest
      self.guest
    end
  end

  private

  def guest_or_user
    unless guest.nil? ^ user.nil?
      errors.add(:guest_or_user, "Must belong to either a guest or a user")
    end
  end

end
