#!/usr/bin/env ruby

require 'rounding'

def get_blinds(players, chips, demoninations, tournament_length, max_time_over, round_length, first_small_blind)
  # tournament_length and round_length in minutes
  # at tournament_length ~5% of total chips can be small blind
  # at last_round ~25% of total chips can be small blind
  total_chips = players * chips
  smallest_denomination = demoninations.min
  number_of_rounds = tournament_length/round_length
  extra_rounds = (max_time_over/round_length)+1
  p number_of_rounds
  p extra_rounds
  (0..tournament_length+max_time_over).step(round_length).each_with_index do |time, i|
    round = i+1
    if round <= number_of_rounds
      small_blind = total_chips*((0.05/number_of_rounds)*round)
    elsif time == tournament_length+max_time_over
      # This is the time the tournament has to finish
      small_blind = (total_chips*0.25).round_to(demoninations.max)
    else
      small_blind = 0
    end
    big_blind = small_blind*2
    puts "Round: #{round} @ #{time}"
    puts "Small: #{small_blind}, Big: #{big_blind}"
  end
end

get_blinds(8, 2000, [1,5,10,25,50,100], (60*2.5).to_i, 60, 15, 1)
