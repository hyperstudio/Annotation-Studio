class AnnotationsController < ApplicationController
    before_filter :authenticate_user!

    def index
        loadOptions = {
            :limit =>       100,
            :groups =>      current_user.rep_group_list,
            :subgroups =>   current_user.rep_subgroup_list,
            :host =>        request.host_with_port,
            :user =>        current_user.email,
            :context =>     'dashboard'
        }
        if params[:document_id]
            #loadOptions[:context] = 'document'
            loadOptions[:uri] = request.base_url + '/documents/' + params[:document_id]
        end
        @loadOptions = loadOptions.to_json
    end

    def show
    end
end
