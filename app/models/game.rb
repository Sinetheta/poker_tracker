class Game < ActiveRecord::Base

  include ActiveWarnings

  has_many :players

  after_validation :generate_name, on: :create

  serialize :blinds, Array
  validates :chips, :game_length, :round_length, :blinds,
            :first_small_blind, :smallest_denomination, presence: true
  validates :chips, :round_length, :first_small_blind,
            :smallest_denomination, numericality: { only_integer: true, greater_than: 0 }
  validates :game_length, numericality: { greater_than: 0 }
  validate :enough_players

  scope :in_progress, -> { where(complete: false) }
  scope :completed, -> { where(complete: true) }

  def find_player_by_owner(owner)
    if owner.class == User
      self.players.find_by(user_id: owner.id)
    elsif owner.class == Guest
      self.players.find_by(guest_id: owner.id)
    end
  end

  def players_out
    self.players.select {|player| player.winner == false}
  end

  def winner
    self.players.find_by_winner(true)
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

  protected

  def enough_players
    unless self.players.length > 1
      errors.add(:not_enough_players, "Please supply at least 2 players")
    end
  end

  # Randomly generate an appropriate name
  def generate_name
    names = ["High Card", "Ace King", "Pair", "Two Pair", "Three of a Kind",
             "Straight", "Flush", "Full House", "Four of a Kind", "Straight Flush",
             "Royal Flush", "Action Card", "All In", "Ante", "Big Bet",
             "Bluff", "Check", "Community Card", "Deal", "Dealer's Choice",
             "Flop", "Fold", "Free Card", "Heads Up", "High-low Split",
             "In the Money", "The Nuts", "Over the Top", "Play the Board", "Poker Face",
             "River", "Semi-bluff", "Splash the Pot", "Trips", "Turn", "Under the Gun"]
    valid_names = names - Game.all.map {|game| game = game.name}
    valid_names = names if valid_names.empty?
    self.name = names.sample
  end
end
