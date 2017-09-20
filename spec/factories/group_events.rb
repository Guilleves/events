FactoryGirl.define do
  factory :group_event do
    name Faker::Hipster.sentence
    description Faker::Hipster.paragraph
    date_from Date.today
    date_to Faker::Date.forward(23)
    location(
      {
        city: Faker::Address.city,
        zip_code: Faker::Address.zip_code,
        address: Faker::Address.street_address
      }
    )
  end
end
