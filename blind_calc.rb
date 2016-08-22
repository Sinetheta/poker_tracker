#!/usr/bin/env ruby

def get_blinds(players, chips, demoninations, tournament_length, round_length, first_small_blind)
  # tournament_length and round_length in minutes
  # at tournament_length ~5% of total chips can be small blind
  # at last_round ~25% of total chips can be small blind
  total_chips = players * chips
  smallest_denomination = demoninations.min
  (0..tournament_length+60).step(round_length).each_with_index do |time, i|
    round = i+1
    if i == 0
      small_blind = first_small_blind
      big_blind = first_small_blind*2
    elsif time == tournament_length
      puts "End of tournament time at round #{round}"
    end
    puts "Round: #{round} @ #{time}"
    puts "Small: #{small_blind}, Big: #{big_blind}"
  end
end

get_blinds(7, 1200, [1,5,10,25,50,100], (60*2.5).to_i, 15, 1)
