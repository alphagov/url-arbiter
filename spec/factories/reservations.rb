# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reservation do
    sequence(:path) {|n| "/path#{n}" }
    publishing_app  "publisher"
  end
end
