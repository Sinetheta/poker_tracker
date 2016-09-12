require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.email { Faker::Internet.email }
    sequence(:name) {|n| Faker::Internet.user_name + "#{n}"}
    password = "password"
    f.password password
    f.password_confirmation password
  end
end

