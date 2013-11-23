require 's3file'
class Image < S3File
  @BASE_BUCKET = AnnotationStudio::Application::IMAGE_BUCKET

  def self.BASE_BUCKET
    AnnotationStudio::Application::IMAGE_BUCKET 
  end
  
end
