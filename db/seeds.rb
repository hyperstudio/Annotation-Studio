# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create initial groups for the Annotation Studio application
Role.where(name: 'admin').first_or_create
Role.where(name: 'editor').first_or_create
Role.where(name: 'student').first_or_create
Role.where(name: 'teacher').first_or_create
