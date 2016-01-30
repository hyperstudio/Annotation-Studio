<<<<<<< HEAD
namespace :annotationstudio do
	desc "Set all the user passwords for development"
	task :reset_passwords => :environment do
		users = User.all
		puts "Resetting the passwords for #{users.count} users."
		users.each_with_index { |user,x|
			user.password = "super-secret"
			user.save!
			if x % 1000 == 0
				puts ''
				print "#{x}: "
			elsif x % 100 == 0
				print '+'
			elsif x % 10 == 0
				print '.'
			end
		}
	end
=======
require 'rake'

namespace :annotationstudio do
  
>>>>>>> a3ced88d89856368b1a41860a8d4a6f0c4c16baa
end
