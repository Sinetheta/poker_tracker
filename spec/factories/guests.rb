require 'faker'

FactoryGirl.define do
  factory :guest do |f|
    f.name { Faker::Internet.user_name }
  end
end
