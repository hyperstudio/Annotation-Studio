class ImagesController < S3Controller
  before_filter :authenticate
  load_and_authorize_resource

  def index
    @images = Image.tagged_with(current_user.rep_group_list)
  end
  
  def show
    @image_path = Image.find(params[:id]).path
  end
  
  def new
    @image = Image.new
  end
  
  def create
    if not params[:upload][:image_file].content_type =~ /^image\//
      flash[:error] = "File is not an image."
      redirect_to images_path and return
    end

    new_params = {
      :filename => S3File.create_file_name(params[:name], sanitize_filename(params[:upload][:image_file].original_filename)),
      :bucket => Image.BASE_BUCKET,
      :nickname => params[:name],
      :rep_group_list => params[:group]
    }
    check_duplicate_s3_object(new_params)
    new_image = Image.create(new_params)
    new_params[:data] = params[:upload][:image_file].read
    create_new_s3_object(new_params)
    redirect_to images_path
  end
end
