module Api::V1
  class DocmetaController < ApiController
    respond_to    :json

    def docmeta
      if !params[:slug].nil?
        slug = params[:slug]
        @doc = Document.where(:slug=>s).select(
          :id, :resource_type, :title, :author, :publication_date, 
          :edition, :publisher, :source, :rights_status, 
          :page_numbers, :series, :location, :journal_title,
          :notes).first
        respond_to do |format|
          format.json do
            render json:
              @doc.to_json
          end
        end
      else
        respond_to do |format|
          format.json do
            render json: {error: 'The request is missing a required parameter.'}
          end
        end
      end
    end
  end
end
