object @user
attributes :id, :firstname, :lastname, :first_name_last_initial

node(:first_name_last_initial) { |user| user.first_name_last_initial() }
