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

class BlindsGenerator

  attr_reader :blinds
  attr_reader :first_small_blind
  attr_reader :round_length

  def initialize(game)
    @denominations = [1,5,10,25,50,100,250,500,1000,2000,5000]
    @denominations.select! {|denom| denom >= game.smallest_denomination}
    @possible_blinds = [1,2,3,4,5,6,7,8,10,15,20,25,30,35,40,45,50,60,70,80,100,
                        125,150,175,200,225,250,300,350,400,450,500,600,700,800,1000,
                        1250,1500,1750,2000,2250,2500,2750,3000,3500,4000,5000,
                        6000,7000,8000,9000,10000,11000,12000,14000,16000,18000,
                        20000,25000,30000,35000,40000,45000,50000]
    @possible_blinds.select! {|blind| blind >= game.smallest_denomination}
    @possible_round_lengths = [5, 10, 15, 20, 30, 45, 60, 90, 120]
    @round_length = @possible_round_lengths.min_by {|length| (length-game.round_length).abs}
    @blind_at_game_end = poker_value((game.total_chips*0.05))
    @first_small_blind = generate_first_small_blind(game.chips)
    @blinds = [@first_small_blind]
    @total_chips = game.total_chips
    @game_length = (game.game_length*60).to_i
    generate_blinds()
  end

  def poker_value(n)
    @possible_blinds.min_by { |x| (n-x).abs }
  end

  def generate_first_small_blind(chips)
    poker_value(chips*0.01)
  end

  def generate_blinds

    blinds_function = ExponentialSecant.new(@first_small_blind, @game_length, @blind_at_game_end)
    blinds = @blinds
    round = 0
    duplicates = 0

    while blinds.last < (@blind_at_game_end*2)
      time = @round_length*round
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
    blinds << @blind_at_game_end
    blinds << blinds.last*2

    duplicates.times do
      blinds << blind_to_insert()
      blinds.reject! { |blind| blind.nil? }
      blinds.sort!
    end

    @blinds = blinds.sort.uniq
    insert_or_remove_blinds()
    adjust_round_length()
  end

  def blind_to_insert
    spaces = @blinds.select {|blind| blind <= @blind_at_game_end }.each_cons(2).each_with_index.map do |b, i|
      if b[1]-b[0] >= 2*@first_small_blind
        [b[1]/b[0].to_f, i]
      end
    end
    spaces.reject! {|space| space.nil? }
    space = spaces.max_by {|space| space[0]}
    if space.nil?
      return nil
    else
      poker_value(((@blinds[space[1]+1]-@blinds[space[1]])/2.0)+@blinds[space[1]])
    end
  end

  # Insert or remove blinds in order to achieve desired game_length
  def insert_or_remove_blinds
    measured_game_length = (@blinds.select {|blind| blind <=@blind_at_game_end}.length-1)*@round_length
    time_off_by = measured_game_length-@game_length
    if time_off_by.abs >= @round_length
      if time_off_by < 0
        time_off_by.abs.divmod(@round_length)[0].times do
          @blinds << blind_to_insert()
          @blinds.reject! { |blind| blind.nil? }
          @blinds.sort!
          @blinds.uniq!
        end
      else
        time_off_by.divmod(@round_length)[0].times do
          @blinds.delete_at(@blinds.each_cons(3).each_with_index.sort_by {|b, i| b[2]/b[0].to_f}.first()[1]+1)
        end
      end
    end
  end

  # Adjust round_length if game_length still not reached
  def adjust_round_length
    blinds_before_game_end = @blinds.select {|blind| blind <=@blind_at_game_end}.length-1
    measured_game_length = blinds_before_game_end*@round_length
    time_off_by = measured_game_length-@game_length
    if time_off_by < 0
      while time_off_by.abs > @round_length && @round_length != @possible_round_lengths.last && time_off_by < 0
        @round_length = @possible_round_lengths[@possible_round_lengths.index(@round_length)+1]
        measured_game_length = blinds_before_game_end*@round_length
        time_off_by = measured_game_length-@game_length
      end
    else
      while time_off_by.abs > @round_length && @round_length != @possible_round_lengths.first && time_off_by > 0
        @round_length = @possible_round_lengths[@possible_round_lengths.index(@round_length)-1]
        measured_game_length = blinds_before_game_end*@round_length
        time_off_by = measured_game_length-@game_length
      end
    end
  end

end
