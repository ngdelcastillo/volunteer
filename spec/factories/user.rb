# Define the user test
FactoryGirl.define do
  factory :user do
    first_name 'Foo'
    last_name 'Test'
    email 'foo_test@x.com'
    password 'secret'
    password_confirmation 'secret'
  end
end
