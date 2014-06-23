# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create initial groups for the Annotation Studio application
Role.where(name: 'admin').first_or_create
Role.where(name: 'teacher').first_or_create
Role.where(name: 'student').first_or_create

email = 'student@example.com'
password = 'password'

user = User.where(email: email).first_or_initialize
user.password = user.password_confirmation = password
user.set_roles = ['student']
user.save

puts "Created user: #{email}, password: #{password}"

document = Document.where(
  title: 'example',
  text: File.read('spec/support/example_files/example.html'),
  user_id: user.id,
  state: 'published',
).first_or_create

document.rep_group_list = 'student'
document.save
