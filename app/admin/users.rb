ActiveAdmin.register User, :as => "Student" do

  scope :all, :default => true

  index do
    column :id
    column :fullname
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :firstname, :as => :string
      f.input :lastname, :as => :string
      f.input :email, :as => :string
      f.input :rep_group_list, :hint => 'Comma separated'
    end
    f.buttons
  end
end
