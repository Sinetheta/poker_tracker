namespace :account do
  desc "Migrate an exisiting guest to an existing user with the same name"
  task migrate_guests: :environment do
    Guest.all.each do |guest|
      user = User.find_by_name(guest.name)
      if user.nil?
        user = User.create(name: guest.name, email: "#{guest.name.gsub(/ /, '_').downcase}@stembolt.io", password: "stembolt", password_confirmation: "stembolt")
      end
      guest.players.each do |player|
        player.user = user
        player.guest = nil
        player.save
      end
    end
  end
  desc "Merge lowercase guests with capitalized guests"
  task merge_lowercase_guests: :environment do
    lowercase = Guest.all.select { |guest| guest.name == guest.name.downcase }
    lowercase.each do |guest|
      capitalized = Guest.find_by_name(guest.name.capitalize)
      if capitalized == nil
        guest.name = guest.name.capitalize
        guest.save
      else
        guest.players.each do |player|
          player.guest = capitalized
          player.save
        end
      end
    end
  end
end
