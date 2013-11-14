FactoryGirl.define do
  factory :user do
    name     "Peter Yu"
    email    "cpeteryu@gmail.com"
    password "foobar"
    password_confirmation "foobar"
  end
end