FactoryBot.define do
  factory :warehouse do
    name { Faker::Name.name }
    association :origin_location, factory: :location
  end
end
