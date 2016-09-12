class Game < ActiveRecord::Base

  require 'generated_game_attributes.rb'

  has_many :players, dependent: :destroy
  before_destroy :remove_player_associations

  serialize :blinds, Array
  validates :chips, :game_length, :round_length, :blinds,
            :first_small_blind, :smallest_denomination, presence: true
  validates :chips, :round_length, :first_small_blind,
            :smallest_denomination, numericality: { only_integer: true, greater_than: 0 }
  validates :game_length, numericality: { greater_than: 0 }
  validate :first_blind_not_less_than_smallest_denomination
  validate :round_not_longer_than_game
  validate :chips_enough_to_start
  validate :enough_players
  validate :enough_total_chips

  after_validation :generate_attributes, on: :create

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

  def generate_attributes
    attributes = GeneratedGameAttributes.new(self)
    self.blinds = attributes.blinds
    self.name = attributes.name
    self.round_length = attributes.round_length
  end

  def enough_players
    unless self.players.length > 1
      errors.add(:not_enough_players, "Specify at least 2 players")
    end
  end

  def enough_total_chips
    unless self.chips * self.players.length > 20 * first_small_blind
      errors.add(:not_enough_chips, "Specify at least 20 times your first small blind in total chips")
    end
  end

  def round_not_longer_than_game
    unless self.round_length <= (self.game_length*60).to_i
      errors.add(:round_too_long, "Specify a round length less than or equal to your game length")
    end
  end

  def first_blind_not_less_than_smallest_denomination
    unless self.first_small_blind >= self.smallest_denomination
      errors.add(:first_blind_too_small, "Specify a first small blind greater than or equal to your smallest denomination")
    end
  end

  def chips_enough_to_start
    unless self.chips >= self.first_small_blind*2
      errors.add(:not_enough_chips, "Specify enough chips so that players can afford the first big blind")
    end
  end

  def remove_player_associations
    self.players.each do |player|
      player.owner.players.delete(player.id)
    end
  end

end
