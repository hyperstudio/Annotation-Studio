ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation
 
  filter :email          

  index do                            
    column :email                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    actions                   
  end            
  
  show do |user|
    attributes_table do
      row :email
      row :current_sign_in_at
      row :last_sign_in_at
      row :sign_in_count
    end
  end
             

  form do |f|                         
    f.inputs "Admin Details" do       
      f.input :email
      f.input :password               
      f.input :password_confirmation  
    end
    f.actions do 
      f.action :submit
      f.action :cancel, :wrapper_html => { :class => "cancel" }
    end
  end

  controller do
    def create
      user = User.find_by(:email => params['admin_user'][:email])
      if user
        user.set_roles = ['admin']
        user.save
        super
      else
        flash[:error] = "Could not create AdminUsesr: User with the email "+params['admin_user'][:email].to_s+" not found."
        redirect_to new_admin_admin_user_path
      end
    end
  end

end
