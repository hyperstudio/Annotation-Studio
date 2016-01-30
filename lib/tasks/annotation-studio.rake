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
end