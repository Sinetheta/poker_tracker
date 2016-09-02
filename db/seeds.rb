# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

users = User.create([
  { name: 'Graham', email: 'graham@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Chris', email: 'chris@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Clarke', email: 'clarke@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Adam', email: 'adam@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Matt', email: 'matt@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Amanda', email: 'amanda@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Sean', email: 'sean@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Jordan', email: 'jordan@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Susan', email: 'susan@example.com', password: 'password', password_confirmation: 'password' },
])

game_default_values = {
  game_length: 2.5,
  round_length: 15,
  chips: 2000,
  smallest_denomination: 1,
  first_small_blind: 1,
  buy_in: 10
}

games = Game.create([
  game_default_values.merge({users: users, round: 4, users_out: { users.sample.id.to_s => "4" }})
])
