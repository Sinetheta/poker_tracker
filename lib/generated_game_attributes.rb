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
		# A larger a will decrease change the curve to be less steep to start
		a = 0.7

		denominations = [1,5,10,25,50,100,250,500,1000,2000,5000]
		denominations.select! {|denom| denom >= smallest_denomination}
		number_of_rounds = ((game_length*60)/round_length)+10

		m = first_small_blind
		t = game_length*60
		n = total_chips*0.05

		k = (Math::log(n)-Math::log(m))/t
		s = Math::PI/(2.01*t)

		if k < 0
			blinds = [first_small_blind]
			round_length = (game_length*60).to_i
		else
			blinds = []
			round = 0
			duplicates = 0
			while blinds.last == nil || blinds.last < total_chips/3
				time = round_length*round
				y = ((1-a)*(m*(Math::E**(k*time))))+(a*(1/(Math::cos(s*time))))
				small_blind = round_values(y, denominations)
				puts "After rounding #{small_blind}"
				small_blind = 1 if small_blind == 0
				if blinds.last != nil && small_blind < blinds.last
					small_blind = total_chips/3
				end
				if small_blind != blinds[-1]
					blinds << small_blind
				else
					duplicates += 1
				end
				round += 1
			end

			# Handle duplicates by insertion

		end

		last_blind = blinds.find_index(blinds.min_by { |x| ((total_chips*0.05)-x).abs })
		if last_blind == 1
			round_length = (game_length*60).to_i
		elsif (game_length*60).to_i > (last_blind*round_length)
			stretch = (game_length*60).to_i - (last_blind*round_length)
			round_length += blinds.length.divmod(stretch)[0]
		end
		@blinds = blinds.sort
		@round_length = round_length
	end
end
