class Game < ActiveRecord::Base
  after_validation :convert_game_length, on: :create
  after_validation :generate_blinds, on: :create
  after_validation :generate_name, on: :create

  serialize :blinds, Array
  validates :players, :chips, :game_length, :round_length, presence: true
  validates :players, :chips, numericality: { only_integer: true, greater_than: 0 }

  protected

  def sensibly_round(n, denominations)
    closest_denom = denominations.min_by { |x| (n-x).abs }
    # Round to the closest denomination if within 10%
    if (n-closest_denom).abs/closest_denom <= 0.1
      return n.round_to(closest_denom)
    end
    # Maybe we should try rounding against multple denoms to get a better result
    denominations.sort.each_with_index do |denomination, i|
      if n < denomination*10
        return n.round_to(denomination)
      end
    end
    return n.round_to(denominations[-1])
  end

  def convert_game_length
    self.game_length = self.game_length*60
  end

  def generate_name
    names = ["High Card",
             "Ace King",
             "Pair",
             "Two Pair",
             "Three of a Kind",
             "Straight",
             "Flush",
             "Full House",
             "Four of a Kind",
             "Straight Flush",
             "Royal Flush"]
    self.name = names.sample
  end

  def generate_blinds
    if errors.empty?
      # tournament_length and round_length in minutes
      # at tournament_length ~5% of total chips can be small blind
      denominations = [1,5,10,25,50,100,500,1000,5000,10000]
      first_small_blind = 1

      total_chips = self.players * self.chips
      number_of_rounds = (self.game_length/self.round_length)+6
      # http://www.maa.org/book/export/html/115405
      k = (Math::log((total_chips*0.05).abs)-Math::log(first_small_blind.abs))/self.game_length

      blinds = []
      round = 0
      duplicate_errors = 0

      while blinds.length < number_of_rounds
        time = self.round_length*round
        small_blind = sensibly_round(Math::E**(k*time), denominations)
        if small_blind == blinds[-1]
          duplicate_errors += 1
        else
          blinds << small_blind
        end
        round += 1
      end
      blinds.select! {|blind| blind < total_chips/3}
      if duplicate_errors
        # Find where the final position should be and calculate round times
        last_blind = blinds.find_index(blinds.min_by { |x| ((total_chips*0.05)-x).abs })
        self.round_length = self.game_length/last_blind
      end
      self.blinds = blinds
    end
  end

end
