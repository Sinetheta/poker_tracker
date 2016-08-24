class Game < ActiveRecord::Base
  after_validation :generate_blinds, on: :create

  serialize :blinds, Array
  validates :name, :players, :chips, :game_length, :round_length, presence: true
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

  def generate_blinds
    if errors.empty?
      # tournament_length and round_length in minutes
      # at tournament_length ~5% of total chips can be small blind
      denominations = [1,5,10,25,50,100,500,1000,5000,10000]
      first_small_blind = 1
      extra_time = self.round_length*6
      total_chips = self.players * self.chips
      number_of_rounds = self.game_length/self.round_length
      # http://www.maa.org/book/export/html/115405
      k = (Math::log((total_chips*0.05).abs)-Math::log(first_small_blind.abs))/self.game_length
      blinds = []
      (0..self.game_length+extra_time).step(self.round_length).each_with_index do |time, i|
        round = i+1
        small_blind = sensibly_round(Math::E**(k*time), denominations)
        if small_blind == blinds[-1]
          # Duplicates occur in games with many rounds and games with few chips
          # Games with duplicates might move faster than expected
        else
          blinds << small_blind unless small_blind > total_chips/3
        end
      end
      self.blinds = blinds
    end
  end

end
