require 'json'

class AnnotationsController < ApplicationController
    before_action :authenticate_user!

    def index	
        loadOptions = {	
            :limit =>       1000,		
            :group_ids =>      current_user.groups.pluck(:id),	
            :host =>        request.host_with_port,	
            :user =>        current_user.email,	
            :context =>     'search'	
        }	
        if params[:document_id]	
            loadOptions[:uri] = request.base_url + '/documents/' + params[:document_id]	
        end	
        @jwttoken = session['jwt']	
        @loadOptions = loadOptions.to_json	
        @document_list = Document.select(:slug, :title) # for getting document name in annotations table.	
        respond_to do |format|	
            format.html { render :index }	
            format.json { render json: ApiRequester.search(loadOptions, @jwttoken) }	
            format.csv { send_data ApiRequester.search(loadOptions, @jwttoken, to_csv: true) }	
        end	
    end
    
    def search
        @method = params['method']
        @query = params['search']
        @document_list = Document.select(:slug, :title)
    end

    def field
        loadOptions = {
            :context =>     'search'
        }
        if params[:field]
            loadOptions[:field] = params[:field]
        end
        if params[:document_id]
            loadOptions[:uri] = request.base_url + '/documents/' + params[:document_id]
        end
        @jwttoken = session['jwt']
        @loadOptions = loadOptions.to_json

        json = ApiRequester.field(loadOptions, @jwttoken)

        if params[:field] == "tags"
            json["tags"].each do |tag|
                tag['text'] = tag['name']
            end
        end

        if params[:field] == "annotation_categories"
            json["annotation_categories"].each do |category|
                category["text"] = AnnotationCategory.find(category['id']).name
            end
        end

        if params[:field] == "user"
            json["user"].each do |user|
                author = User.find_by_email(user['id'])
                if author.present?
                    user["text"] = "#{author.firstname} #{author.lastname[0]}."
                else
                    next
                end
            end
        end

        respond_to do |format|
            format.json { render json: json }
        end
    end

    def create(params)
        @jwttoken = session['jwt']
        ApiRequester.create(params, @jwttoken)
    end

    def show

    end

    def exception_test
        raise "This is a test of the exception handler. If you received this email, it is working properly."
    end
end
