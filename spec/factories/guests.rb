require 'faker'

FactoryGirl.define do
  factory :guest do |f|
    sequence(:name) {|n| Faker::Internet.user_name + "#{n}" }
  end
end
