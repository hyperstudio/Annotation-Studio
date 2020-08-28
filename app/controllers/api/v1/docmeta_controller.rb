module Api::V1
  class DocmetaController < ApiController
    before_action :doorkeeper_authorize!
    respond_to :json

    def docmeta
      json_params = JSON.parse(request.raw_post)
      pp json_params
      if !json_params[:slugs].nil?
        @doc = Hash.new
        for slug in json_params[:slugs]
          @doc[slug] = Document.where(:slug => slug).select(
            :id, :resource_type, :title, :author, :publication_date,
            :edition, :publisher, :source, :rights_status,
            :page_numbers, :series, :location, :journal_title,
            :notes
          ).first
        end
        respond_to do |format|
          format.json do
            render json: @doc.to_json
          end
        end
      else
        respond_to do |format|
          format.json do
            render json: { error: "The request is missing a required parameter." }
          end
        end
      end
    end
  end
end
