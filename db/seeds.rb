require "factory_girl"

include FactoryGirl::Syntax::Methods

50.times do |count|
  puts "Creating game ##{count+1}"
  game = create(:game)
  puts "Game created: #{debug game}"
end
