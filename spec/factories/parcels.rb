FactoryBot.define do
  factory :parcel do
    recipient_name { Faker::Name.name }
    weight {Faker::Number.decimal(2)}
    association :destination_location, factory: :location
  end
end
