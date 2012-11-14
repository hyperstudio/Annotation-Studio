ActiveAdmin.register User, :as => "Student" do

  scope :all, :default => true

  index do
    column :id
    column :fullname
    default_actions
  end

  form do |f|
        f.inputs
        f.buttons
  end
end
