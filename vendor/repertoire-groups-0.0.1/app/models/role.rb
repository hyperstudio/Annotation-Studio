class Role < ActiveRecord::Base
  has_many :assignments
  has_many :users, :through => :assignments

  validates_presence_of :name

  def Role.find_or_create_new(name)
    name = name.to_s if name.is_a?(Symbol) # Does this matter?
    Role.find_by_name(name) || Role.create!({:name => name})
  end

  def role_to_sym
    self.name.underscore.to_sym
  end
end
