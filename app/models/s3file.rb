class S3File < Document

  attr_accessible :filename, :bucket, :nickname
  @BASE_BUCKET = AnnotationStudio::Application::BUCKET
  
  # Create File name and make sure it is unique
  def self.create_file_name(nickname, filename)
    DateTime.now.to_s + nickname + filename
  end
  # This will list every single object in the 
  # bucket with no regard to group privacy and the like
  def self.list_all
    AWS::S3::Bucket.find(@BASE_BUCKET).objects
  end

  def self.BASE_BUCKET 
    AnnotationStudio::Application::BUCKET
  end

  # S3 Related Exception
  class S3FileExistsError < Exception
  end
end
