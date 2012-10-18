ActiveAdmin.register User, :as => "Student" do

  scope :all, :default => true

  index do
    column :id
    column :fullname
    default_actions
  end

  form do |f|
        f.inputs "Details" do
          f.input :firstname
          f.input :lastname
          f.input :created_at, :label => "Signup Date"
        end
        f.buttons
      end
end
