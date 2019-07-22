object @user
attributes :id, :firstname, :lastname, :rep_group_list, :first_name_last_initial

node(:first_name_last_initial) { |user| user.first_name_last_initial() }
node(:rep_group_list) { |user| user.rep_group_list() }
