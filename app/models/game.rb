class Game < ActiveRecord::Base

  require 'blinds_generator.rb'
  require 'name_generator.rb'

  has_many :players, dependent: :destroy
  before_destroy :remove_player_associations

  serialize :blinds, Array
  validates :chips, :game_length, :round_length, :blinds,
            :smallest_denomination, presence: true
  validates :chips, :round_length,
            :smallest_denomination, numericality: { only_integer: true, greater_than: 0 }
  validates :game_length, numericality: { greater_than: 0 }
  validate :round_not_longer_than_game
  validate :enough_players

  after_validation :generate_blinds, :generate_name, on: :create

  scope :in_progress, -> { where(complete: false) }
  scope :completed, -> { where(complete: true) }

  def find_player_by_owner(owner)
    if owner.class == User
      self.players.find {|player| player.user_id == owner.id}
    elsif owner.class == Guest
      self.players.find {|player| player.guest_id == owner.id}
    end
  end

  def players_out
    self.players.select {|player| player.winner == false}
  end

  def winner
    self.players.find {|player| player.winner == true}
  end

  def runner_up
    self.players_out.max_by {|player| player.position_out}
  end

  def number_of_players
    self.players.length
  end

  def total_chips
    self.chips * number_of_players
  end

  def declare_winner
    if self.players_out.length == self.number_of_players-1
      winner = self.players.find_by(winner: nil)
      winner.winner = true
      self.complete = true
      self.save
      winner.save
    end
  end

  protected

  def generate_blinds
    blinds = Blinds.new(self)
    self.first_small_blind = blinds.first_small_blind
    self.blinds = blinds.blinds
  end

  def generate_name
    pokername = PokerName.new()
    self.name = pokername.name
  end

  def enough_players
    unless self.players.length > 1
      errors.add(:not_enough_players, "Specify at least 2 players")
    end
  end

  def round_not_longer_than_game
    unless self.round_length <= (self.game_length*60).to_i
      errors.add(:round_too_long, "Specify a round length less than or equal to your game length")
    end
  end

  def remove_player_associations
    self.players.each do |player|
      player.owner.players.delete(player.id)
    end
  end

end
