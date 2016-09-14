class ExponentialSecant

  # Assumes a y intercept at (0, x0)
  def initialize(y0, x1, y1)
    # A smaller (a) will decrease change the curve to be less steep to start
    @a = 0.7
    @k = (Math::log(y1.abs)-Math::log(y0.abs))/x1
    @s = (Math::acos(1/((y1-y0)+1))/x1)
    # s is not being calculated to the accuracy we need, fudging here
    @s = @s*1.01
    @y0 = y0
  end

  def calculate_at_x(x)
    ((1-@a)*(@y0*(Math::E**(@k*x))))+(@a*((1/(Math::cos(@s*x))-1+@y0)))
  end

end

class Blinds

  attr_reader :blinds
  attr_reader :name
  attr_reader :first_small_blind

  def initialize(game)
    @denominations = [1,5,10,25,50,100,250,500,1000,2000,5000]
    @denominations.select! {|denom| denom >= game.smallest_denomination}
    @possible_blinds = [1,2,3,4,5,6,7,8,10,15,20,25,30,35,40,50,60,70,80,100,
                        125,150,175,200,250,300,350,400,500,600,700,800,1000,
                        1250,1500,1750,2000,2250,2500,3000,3500,4000,5000,
                        6000,7000,8000,9000,10000,12000,14000,16000,18000,
                        20000,25000,30000,35000,40000,45000,50000]
    @possible_blinds.select! {|blind| blind >= game.smallest_denomination}
    @blind_at_game_end = poker_value((game.total_chips*0.05))
    @first_small_blind = generate_first_small_blind(game.chips)
    @blinds = [@first_small_blind]
    @total_chips = game.total_chips
    generate_blinds(game.game_length, game.round_length)
  end

  def poker_value(n)
    @possible_blinds.min_by { |x| (n-x).abs }
  end

  def generate_first_small_blind(chips)
    poker_value(chips*0.01)
  end

  def generate_blinds(game_length, round_length)

    blinds_function = ExponentialSecant.new(@first_small_blind, (game_length*60).to_i, @blind_at_game_end)
    blinds = @blinds
    round = 0
    duplicates = 0
    while blinds.empty? || blinds.last < (@blind_at_game_end*2)
      time = round_length*round
      small_blind = poker_value(blinds_function.calculate_at_x(time))
      # If we get a blind less than the last one, set a max blind
      # Note: This will only happen with functions that have an asymptote.
      # A blind less than the last means we've passed over the asymptote
      if small_blind < blinds.last
        small_blind = @blind_at_game_end
      end
      if small_blind != blinds[-1]
        blinds << small_blind
      else
        duplicates += 1
      end
      round += 1
    end

    blinds.pop
    blinds << @blind_at_game_end*2

    duplicates.times do
      blinds << blind_to_insert(blinds)
      blinds.reject! { |blind| blind.nil? }
      blinds.sort!
    end

    @blinds = blinds.sort.uniq
  end

  def blind_to_insert(blinds)
    spaces = blinds.select {|blind| blind <= @blind_at_game_end }.each_cons(2).each_with_index.map do |b, i|
      if b[1]-b[0] >= 2*@first_small_blind
        [b[1]/b[0].to_f, i]
      end
    end
    spaces.reject! {|space| space.nil? }
    space = spaces.max_by {|space| space[0]}
    if space.nil?
      return nil
    else
      poker_value(((blinds[space[1]+1]-blinds[space[1]])/2.0)+blinds[space[1]])
    end
  end

  # Insert or remove blinds in order to achieve desired game_length
  def insert_or_remove_blinds
   # Not yet implemented
  end
end
