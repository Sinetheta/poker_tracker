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
  { name: 'Aurelio', email: 'aurelio@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Shaunda', email: 'shaunda@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Sixta', email: 'sixta@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Bert', email: 'bert@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Janee', email: 'janee@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Bari', email: 'bari@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Lynetta', email: 'lynetta@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Nu', email: 'nu@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Jerrie', email: 'jerrie@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Jamee', email: 'jamee@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Tisha', email: 'tisha@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Ruthie', email: 'ruthie@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Filomena', email: 'filomena@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Kaitlyn', email: 'kaitlyn@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Ilene', email: 'ilene@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Julene', email: 'julene@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Nora', email: 'nora@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Fidela', email: 'fidela@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Charlesetta', email: 'charlesetta@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Ralph', email: 'ralph@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Natosha', email: 'natosha@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Ernestina', email: 'ernestina@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Evelyne', email: 'evelyne@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Marissa', email: 'marissa@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Tracey', email: 'tracey@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Francoise', email: 'francoise@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Tonie', email: 'tonie@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Ignacio', email: 'ignacio@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Antione', email: 'antione@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Ha', email: 'ha@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Shandi', email: 'shandi@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Galina', email: 'galina@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Brendon', email: 'brendon@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Tamar', email: 'tamar@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Patrina', email: 'patrina@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Elli', email: 'elli@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Nobuko', email: 'nobuko@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Irwin', email: 'irwin@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Kathern', email: 'kathern@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Charis', email: 'charis@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Clarisa', email: 'clarisa@example.com', password: 'password', password_confirmation: 'password' },
  { name: 'Fumiko', email: 'fumiko@example.com', password: 'password', password_confirmation: 'password' }
])

guests = Guest.create([
  { name: 'Jonas' },
  { name: 'Garret' },
  { name: 'Ty' },
  { name: 'Laraine' },
  { name: 'Brad' },
  { name: 'Cordell' },
  { name: 'Dorinda' },
  { name: 'Stan' },
  { name: 'Mindy' },
  { name: 'Rosena' },
  { name: 'Angele' },
  { name: 'Somer' },
  { name: 'Shenita' },
  { name: 'Roland' },
  { name: 'Violette' },
  { name: 'Billi' },
  { name: 'Gertrude' },
  { name: 'Rochell' },
  { name: 'Lashawna' },
  { name: 'Florrie' },
  { name: 'Krystle' },
  { name: 'Jocelyn' },
  { name: 'Felicitas' },
  { name: 'Shanika' },
  { name: 'Sherell' },
  { name: 'Stevie' },
  { name: 'Denae' },
  { name: 'Tena' },
  { name: 'Yer' },
  { name: 'Mark' },
  { name: 'Esther' },
  { name: 'Anjelica' },
  { name: 'Cristopher' },
  { name: 'Chin' },
  { name: 'Marceline' },
  { name: 'Adrien' },
  { name: 'Keturah' },
  { name: 'Lisbeth' },
  { name: 'Carmine' },
  { name: 'Alexia' },
  { name: 'Devora' },
  { name: 'Phillis' },
  { name: 'Riley' },
  { name: 'Samella' },
  { name: 'Barabara' },
  { name: 'Adelle' },
  { name: 'Loida' },
  { name: 'Gia' },
  { name: 'Mirtha' },
  { name: 'Bernie' }
])

game_default_params = {
  game_length: 2.5,
  round_length: 15,
  chips: 2000,
  smallest_denomination: 1,
  first_small_blind: 1,
  buy_in: 10
}

50.times do |i|
  game = Game.new(game_default_params)
  users.shuffle.take(Random.rand(2..10)).each do |user|
    game.players << Player.create(user: user, game_id: game.id)
  end
  guests.shuffle.take(Random.rand(2..10)).each do |guest|
    game.players << Player.create(guest: guest, game_id: game.id)
  end
  game.save()
  game.players.shuffle.take(game.players.length-1).each do |player|
    player.round_out = Random.rand(10)
    player.position_out = game.players_out.length
    player.winner = false
    player.save()
  end
  winner = game.players.find_by(winner: nil)
  winner.winner = true
  game.complete = true
  game.round = game.players_out.max_by {|player| player.round_out}.round_out
  game.save()
  winner.save()
end
