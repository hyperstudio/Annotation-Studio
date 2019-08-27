FactoryGirl.define do  factory :documents_group do
    
  end
  factory :invite do
    
  end
  factory :membership do
    group_id 1
user_id 1
role "MyString"
  end
  factory :group do
    
  end

  factory :user do
    email 'foo@example.com'
    password '123pass'
  end

  factory :document do
    title 'Title'
    text 'I am a body.'
  end

  factory :tenant do
    sequence (:domain) { |n|  "www#{n}.example.com" }
    sequence (:database_name) { |n|  "www#{n}" }
  end
end
