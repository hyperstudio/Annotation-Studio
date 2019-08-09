# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

default_tenants = ['public', 'www']

default_tenants.each do |tenant|
  if tenant != 'public'
    Tenant.where(database_name: tenant, domain: "#{tenant}.localhost").first_or_create
    Apartment::Tenant.switch(tenant)
  else
    # Use the default 'public' schema
    Apartment::Tenant.reset
  end

  # Create initial groups for the Annotation Studio application
  Role.where(name: 'admin').first_or_create
  Role.where(name: 'teacher').first_or_create
  Role.where(name: 'student').first_or_create

  email = 'student@example.com'
  password = 'password'

  user = User.where(email: email).first_or_initialize
  user.password = user.password_confirmation = password
  user.agreement = true
  user.set_roles = ['student']
  user.save

  puts "Created user: #{email}, password: #{password}"

  admin = AdminUser.where(email: 'admin@example.com').first_or_initialize
  admin.password = admin.password_confirmation = password
  # admin.agreement = true
  admin.save

  puts "Created AdminUser: 'admin@example.com', password: #{password}"

    document = Document.where(
      title: 'example',
      text: File.read('spec/support/example_files/example.html'),
      user_id: user.id,
      state: 'published',
  ).first_or_create

  document.rep_group_list = 'student'
  document.save
end

puts "We seeded the default 'public' schema and the following default tenants:\n"

puts default_tenants.reject { |tenant| tenant == 'public'}.join("\n")

puts "\nIf you point one of those tenant names at your running rails app as a domain,
apartment will switch you to the separate contexts. So, by default:

www.localhost -> switches to the 'www' tenant
localhost -> uses the default 'public' schema
"
