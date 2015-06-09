class AnnotationsController < ApplicationController
    before_filter :authenticate_user!

    def index
        loadOptions = {
            :limit =>       100,
            :groups =>      current_user.rep_group_list,
            :subgroups =>   current_user.rep_subgroup_list,
            :host =>        request.host_with_port,
            :user =>        current_user.email,
            :context =>     'search'
        }
        if params[:document_id]
            loadOptions[:uri] = request.base_url + '/documents/' + params[:document_id]
        end
        @token = session['jwt']
        @loadOptions = loadOptions.to_json

        respond_to do |format|
            format.html { render :index }
            format.json { render json: ApiRequester.search(loadOptions, @token) }
            format.csv { send_data ApiRequester.search(loadOptions, @token, to_csv: true) }
        end
    end

    def show
    end
end
