class GeneratedGameAttributes

  attr_reader :blinds
  attr_reader :round_length
  attr_reader :name

  def initialize(game)
    @blinds = []
    @round_length = round_length
    @name = generate_name
    generate_blinds(game.game_length, game.round_length, game.total_chips,
                    game.smallest_denomination, game.first_small_blind)
  end

  def round_values(n, denominations)
    puts "Before rounding: #{n}"
    # Round to a roughly reasonable denomination
    denominations.sort.each do |denomination|
      if n < denomination*10
        return n.floor_to(denomination)
      end
    end
    return n.floor_to(denominations[-1])
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

  def generate_blinds(game_length, round_length, total_chips, smallest_denomination, first_small_blind)
    denominations = [1,5,10,25,50,100,250,500,1000,2000,5000]
    denominations.select! {|denom| denom >= smallest_denomination}
    number_of_rounds = ((game_length*60)/round_length)+10
    # http://www.maa.org/book/export/html/115405
    k = (Math::log(total_chips*0.05)-Math::log(first_small_blind))/(game_length*60)
    
    puts "k = #{k}"

    if k < 0
      blinds = [first_small_blind]
      round_length = (game_length*60).to_i
    else
      blinds = []
      round = 0
      while blinds.last == nil || blinds.last < total_chips/3
        time = round_length*round
        small_blind = round_values(first_small_blind*(Math::E**(k*time)), denominations)
        puts "After rounding #{small_blind}"
        small_blind = 1 if small_blind == 0
        if small_blind != blinds[-1]
          blinds << small_blind
        # Special case for a repeat 1 blind
        elsif small_blind == 1
          blinds << 2
        end
        round += 1
      end
      last_blind = blinds.find_index(blinds.min_by { |x| ((total_chips*0.05)-x).abs })
      if last_blind == 0
        round_length = (game_length*60).to_i
      elsif (game_length*60).to_i > (last_blind*round_length)
        stretch = (game_length*60).to_i - (last_blind*round_length)
        round_length += blinds.length.divmod(stretch)[0]
      end
    end
    @blinds = blinds
    @round_length = round_length
  end
end
