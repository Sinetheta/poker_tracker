class ExponentialSecant

  # Assumes a y intercept at (0, x0)
  def initialize(a, y0, x1, y1)
    @k = (Math::log(y1.abs)-Math::log(y0.abs))/x1
    @s = (Math::acos(1/((y1-y0)+1))/x1)
    # s is not being calculated to the accuracy we need, fudging here
    @s = @s*1.01
    @y0 = y0
    @a = a
  end

  def calculate_at_x(x)
    ((1-@a)*(@y0*(Math::E**(@k*x))))+(@a*((1/(Math::cos(@s*x))-1+@y0)))
  end

end

class GeneratedGameAttributes

  attr_reader :blinds
  attr_reader :round_length
  attr_reader :name
  attr_reader :first_small_blind

  def initialize(game)
    @denominations = [1,5,10,25,50,100,250,500,1000,2000,5000]
    @denominations.select! {|denom| denom >= game.smallest_denomination}
    @blinds = []
    @round_length = game.round_length
    @name = generate_name
    @first_small_blind = generate_small_blind(game.chips)
    generate_blinds(game.game_length, @round_length, game.total_chips, @first_small_blind)
  end

  def round_values(n, denominations)
    closest_denom = denominations.min_by { |x| (n-x).abs }
    if (n-closest_denom).abs/closest_denom <= 0.1
      return n.round_to(closest_denom)
    end
    # Round to a roughly reasonable denomination
    denominations.sort.each do |denomination|
      if n < denomination*10
        return n.floor_to(denomination)
      end
    end
    return n.floor_to(denominations[-1])
  end

  def generate_small_blind(chips)
    round_values(chips*0.015, @denominations)
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
    names.sample
  end

  def generate_blinds(game_length, round_length, total_chips, first_small_blind)

    # A larger (a) will decrease change the curve to be less steep to start
    a = 0.7

    # If the first blind is above 5% of total chips, make a single round game
    if total_chips/20.0 < first_small_blind
      blinds = [first_small_blind]
      round_length = (game_length*60).to_i
    else
      blinds_function = ExponentialSecant.new(a, first_small_blind, (game_length*60).to_i, (total_chips/10.0).to_i)
      blinds = []
      round = 0
      duplicates = 0
      while blinds.empty? || blinds.last < total_chips/10
        time = round_length*round
        small_blind = round_values(blinds_function.calculate_at_x(time), @denominations)
        small_blind = 1 if small_blind == 0
        # If we get a blind less than the last one, set a max blind
        # Note: This will only happen with functions that have an asymptote.
        # A blind less than the last means we've passed over the asymptote
        if !blinds.empty? && small_blind < blinds.last
          small_blind = total_chips/3
        end
        if small_blind != blinds[-1]
          blinds << small_blind
        else
          duplicates += 1
        end
        round += 1
      end

      blinds.pop
      blinds << round_values(total_chips/10, @denominations)

      # Handle duplicates by insertion
      # Find the largest gaps, proportionally
      spaces = blinds.each_cons(2).each_with_index.map do |b, i|
        if b[1]-b[0] >= 2
          [b[1]/b[0].to_f, i]
        end
      end
      spaces = spaces.reject {|space| space.nil? }.sort_by {|space| space[0]}.reverse
      spaces.map! {|space| space[1]}
      if spaces.length < duplicates
        blinds = nil
      else
        spaces = spaces.take(duplicates)
        spaces.map do |space|
          blinds << round_values(((blinds[space+1]-blinds[space])/2.0)+blinds[space], @denominations)
        end
      end
      blinds
    end

    @blinds = blinds.sort.uniq
  end
end
