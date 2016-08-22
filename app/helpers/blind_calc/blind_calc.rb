#!/usr/bin/env ruby

require 'rounding'

def sensibly_round(n, denominations)
  denominations.sort.each do |denomination|
    if n < denomination*5
      return n.round_to(denomination)
    end
  end
  return n.round_to(denominations[-1])
end

def get_blinds(players, chips, denominations, tournament_length, round_length, first_small_blind)
  # tournament_length and round_length in minutes
  # at tournament_length ~5% of total chips can be small blind
  # at last_round ~25% of total chips can be small blind
  extra_time = round_length*6
  total_chips = players * chips
  smallest_denomination = denominations.min
  number_of_rounds = tournament_length/round_length
  # http://www.maa.org/book/export/html/115405
  # Calculate a function so that at the end of play time, small blind is 10% of
  # total chips
  k = (Math::log((total_chips*0.05).abs)-Math::log(first_small_blind.abs))/tournament_length
  blinds = []
  (0..tournament_length+extra_time).step(round_length).each_with_index do |time, i|
    round = i+1
    small_blind = sensibly_round(Math::E**(k*time), denominations)
    blinds << small_blind unless small_blind == blinds[-1]
  end
  blinds
end

get_blinds(7, 2000, [1,5,10,25,50,100,500,1000], 150, 15, 1).each_with_index do |blind, i|
  puts "Time: #{((i+1)*15)/60.0} -- Small #{blind} -- Big #{blind*2}"
end


# Example (8, 2000, [1,5,10,25,50,100], (60*2.5).to_i, 60, 15, 1)
# => [1,2,4,7,14,30,50,100,200,400,800,1500,3000,6000,12000]
# 100, 100, 75, 100, ~100, 66, 100, 100, 100, 100,
