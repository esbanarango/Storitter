FactoryGirl.define do
  factory :user do
  	sequence(:username)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}  
    first_name 	"Esteban"
    last_name	"Arango"
  end
end