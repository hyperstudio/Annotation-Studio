module Repertoire
  module Groups
    module RoleUser
      extend ActiveSupport::Concern

      module ClassMethods
        def acts_as_role_user
          class_eval do
            has_many :assignments
            has_many :roles, :through => :assignments

            after_initialize :set_default_roles
            before_save :remove_unapproved
            validate :must_have_at_least_one_role
          end
        end
      end

      def set_roles=(new_roles)
        new_roles = [] if new_roles.nil?
        roles.clear
        new_roles.each do |role|
          unless has_role?(role.underscore.to_sym)
            roles << [ Role.find_or_create_new(role) ]
          end
        end

        set_default_roles
      end

      # Via: https://github.com/ryanb/cancan/wiki/Separate-Role-Model
      def has_role?(role_sym)
        get_role(role_sym) != nil
      end

      def get_role(role_sym)
        roles.detect { |r| r.role_to_sym == role_sym }
      end

      def set_default_roles
        if (roles.size == 0)
          roles << Role.find_or_create_new(:student)
        end
      end

      def remove_unapproved
        if roles.length > 1 && has_role?(:unapproved)
          self.set_roles = roles.collect {|r| r.name if r.name != 'unapproved'}.compact
        end
      end

      def must_have_at_least_one_role
        errors.add(:roles, "must not be empty (Users must have at least one role)") if
          roles.length == 0
      end
    end
  end
end

ActiveRecord::Base.send :include, Repertoire::Groups::RoleUser
