ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Info" do
          h4 "Welcome to ActiveAdmin."
          h3 "Responding to a GDPR data request?"
          ol do
            li ("Go to the " + link_to('Users tab', admin_users_path)+".").html_safe
            li "Look up the user by name or email address in the filter sidebar."
            li "Click on \"View\" in the rightmost table column (in the row for the requesting user)."
            li "Click the link that says \"Click here to fetch annotations.\""
            li "Once annotations have loaded, print the page to PDF and send to the requesting user."
            li "If you are also responding to a deletion request, click \"Delete User\" in the top right."
          end
          h3 "Need to give someone access to ActiveAdmin?"
          ol do
            li ("Go to the " + link_to('Admin Users tab', admin_admin_users_path) +".").html_safe
            li "Click the \"New Admin User\" button in the top right."
            li "Enter the person's email and a temporary password."
            li ("Instruct the person to change their password by navigating to the "+ link_to('Admin Users tab', admin_admin_users_path) + " and clicking \"Edit\" in their table row.").html_safe
          end
          para "Note: The person you are trying to give access to must already have an Annotation Studio account associated with that email."
        end
      end
    end
  end # content
end
