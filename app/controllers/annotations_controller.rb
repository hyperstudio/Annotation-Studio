require 'json'

class AnnotationsController < ApplicationController
    before_action :authenticate_user!

    
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
        @token = session['jwt']
        @loadOptions = loadOptions.to_json

        json = ApiRequester.field(loadOptions, @token)

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
        @token = session['jwt']
        ApiRequester.create(params, @token)
    end

    def show

    end

    def exception_test
        raise "This is a test of the exception handler. If you received this email, it is working properly."
    end
end
