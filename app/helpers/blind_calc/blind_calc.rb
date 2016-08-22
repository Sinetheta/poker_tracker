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
  (0..tournament_length+max_time_over).step(round_length).each_with_index do |time, i|
    # exponential function?
    # y = (((tournament_length/60)x^3)/(total_chips*2))+first_small_blind
    round = i+1
    if round == 1
      small_blind = 1
    elsif round <= number_of_rounds
      small_blind = (((1/(tournament_length/60.0))*(time**3.65))/(total_chips*2))+(first_small_blind*2)
    elsif round > number_of_rounds
      small_blind = (((1/(tournament_length/60.0))*(time**3.65))/(total_chips*2))+(first_small_blind*2)
    end
    if small_blind < 10
      small_blind= small_blind.round_to(1)
    elsif small_blind < 100
      small_blind = small_blind.round_to(10)
    elsif small_blind < 500
      small_blind = small_blind.round_to(50)
    else
      small_blind = small_blind.round_to(100)
    end
    big_blind = small_blind*2
    puts "Round: #{round} @ #{time}"
    puts "Small: #{small_blind}, Big: #{big_blind}"
  end
end

get_blinds(16, 20000, [1,5,10,25,50,100], 240, 60, 15, 1)


# Example (8, 2000, [1,5,10,25,50,100], (60*2.5).to_i, 60, 15, 1)
# => [1,2,4,7,14,30,50,100,200,400,800,1500,3000,6000,12000]
# 100, 100, 75, 100, ~100, 66, 100, 100, 100, 100,
