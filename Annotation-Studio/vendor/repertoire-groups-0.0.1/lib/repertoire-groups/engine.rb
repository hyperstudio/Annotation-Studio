module Repertoire
  module Groups
    class Engine < Rails::Engine
      initializer 'application_controller_extension.controller' do |app|
        ActiveSupport.on_load(:action_controller) do  
          # include Repertoire::Groups::ApplicationControllerExtension
        end
      end
    end
  end
end
