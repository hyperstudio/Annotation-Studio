FactoryGirl.define do
  factory :user do
    email 'foo@example.com'
    password '123pass'
  end

  factory :document do
    title 'Title'
    text 'I am a body.'
  end

end
