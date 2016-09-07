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

def generate_blinds(game_length, round_length, total_chips, smallest_denomination, first_small_blind)
  denominations = [1,5,10,25,50,100,250,500,1000,2000,5000]
  denominations.select! {|denom| denom >= smallest_denomination}
  number_of_rounds = ((game_length*60)/round_length)+10
  # http://www.maa.org/book/export/html/115405
  k = (Math::log(total_chips*0.05)-Math::log(first_small_blind))/(game_length*60)

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
  blinds.select! {|blind| blind < total_chips/3}
  # If duplicate errors occured, adjust round_length to compensate
  if duplicate_errors > 0
    last_blind = blinds.find_index(blinds.min_by { |x| ((total_chips*0.05)-x).abs })
    puts last_blind
    if !last_blind || last_blind == 0
      blinds = nil
    else
      adjusted_round_length = round_values(((game_length*60)/last_blind).to_i, [1,2,5,10])
      if adjusted_round_length != round_length
        round_length = adjusted_round_length
      end
    end
  end
  {blinds: blinds, round_length: round_length}
end
