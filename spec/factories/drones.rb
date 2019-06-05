FactoryBot.define do
  factory :drone do
    name { Faker::Name.name }
    description {Faker::Lorem.paragraph}
    association :current_location, factory: :location
    association :parking_location, factory: :location
    association :destination_location, factory: :location
  end
end

