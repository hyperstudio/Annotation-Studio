#
# Based on this idea:
#  http://stackoverflow.com/questions/972857/multiple-objects-in-a-rails-form
#

class UserSet
  include ActiveRecord::Validations
  attr_accessor :users

  validate :all_users_valid

  def all_users_valid
    @users.each do |user|
      errors.add user.errors unless user.valid?
    end
  end

  def initialize
    super
    @users = User.all
    # raise @users.detect {|u| u.id == 7}.roles.inspect
  end

  def save
    @users.all?(&:save)
  end

  # This is pretty inflexible now, should be set up
  # to handle user attributes more flexibly, so the administrative
  # page can be expanded?
  def users_attributes(params)
    params.each_key do |uid|
      user = @users.detect {|u| u.id == uid.to_i}
      user.set_roles = params[uid]['roles']
      user.rep_group_list << params[uid]['rep_group_list'] unless params[uid]['rep_group_list'].empty?
      user.rep_group_list << params[uid]['rep_group_list_add'] unless params[uid]['rep_group_list_add'].empty?

      if params[uid]['rep_group_remove']
        user.rep_group_list = user.rep_group_list - params[uid]['rep_group_remove']
      end

      user.save # I have to save this? I guess so.
    end
  end
end
