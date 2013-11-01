class ImagesController < ApplicationController
  def index
    @images = Image.all()
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
    path = ImageFile.save(params[:upload])
    params[:image][:path] = path
    @image = Image.create!(params[:image])
    redirect_to images_path
  end
end
