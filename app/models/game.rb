class Game < ActiveRecord::Base

  include ActiveWarnings

  has_many :players

  after_validation :generate_name, :generate_blinds, on: :create

  serialize :blinds, Array
  validates :chips, :game_length, :round_length,
            :first_small_blind, :smallest_denomination, presence: true
  validates :chips, :round_length,
            :first_small_blind, :smallest_denomination, numericality: { only_integer: true, greater_than: 0 }
  validates :game_length, numericality: { greater_than: 0 }

  scope :in_progress, -> { where(complete: false) }
  scope :completed, -> { where(complete: true) }
  scope :winner, ->(player) { where(winner: player.owner) }

  def player_out_round(player)
    if self.players_out.keys.include?(player)
      return self.players_out[player][0]
    else
      return nil
    end
  end

  def players_out
    Player.out_in_game(self)
  end

  def winner
    self.players.find_by_winner(true)
  end

  def number_of_players
    self.players.length
  end

  def total_chips
    self.chips * number_of_players
  end

  protected

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

  def generate_blinds
    def round_values(n, denominations)
      # Round to the closest denomination if within 10%
      closest_denom = denominations.min_by { |x| (n-x).abs }
      if (n-closest_denom).abs/closest_denom <= 0.1
        return n.round_to(closest_denom)
      end
      # Round to a roughly reasonable denomination
      denominations.sort.each_with_index do |denomination, i|
        if n < denomination*10
          return n.round_to(denomination)
        end
      end
      return n.round_to(denominations[-1])
    end

    if errors.empty?
      denominations = [1,5,10,25,50,100,250,500,1000,2000,5000]
      denominations.select! {|denom| denom >= self.smallest_denomination}
      number_of_rounds = ((self.game_length*60)/round_length)+10
      # http://www.maa.org/book/export/html/115405
      k = (Math::log((self.total_chips*0.05).abs)-Math::log(first_small_blind.abs))/(self.game_length*60)

      blinds = []
      round = 0
      duplicate_errors = 0

      while blinds.length < number_of_rounds && duplicate_errors < 10
        time = round_length*round
        small_blind = round_values(first_small_blind*(Math::E**(k*time)), denominations)
        if small_blind == blinds[-1]
          duplicate_errors += 1
        else
          blinds << small_blind
        end
        round += 1
      end
      # Filter blinds larger than the pot
      blinds.select! {|blind| blind < self.total_chips/3}
      # If duplicate errors occured, adjust round_length to compensate
      if duplicate_errors > 0
        last_blind = blinds.find_index(blinds.min_by { |x| ((self.total_chips*0.05)-x).abs })
        if last_blind == 0
          errors[:blinds] = "Blinds could not be constructed with provided parameters."
        else
          adjusted_round_length = round_values(((self.game_length*60)/last_blind).to_i, [1,2,5,10])
          # Promt the user with the option to adjust round_length
          if adjusted_round_length != round_length
            warnings[:duplicates] = "Round length adjusted to reach desired game length"
            self.round_length = adjusted_round_length
          end
        end
      end
      self.blinds = blinds
    end
  end

end
