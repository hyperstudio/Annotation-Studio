require 'spec_helper'

Factory.define :user do |user|
  user.firstname  { Faker::Name.first_name }
  user.lastname   { Faker::Name.last_name }
  user.email      { Faker::Internet.email }
  user.password   'password'
  user.roles      { [] }
end

Factory.define :test_model do |tm|
  tm.content      "This is some test content!"
end
