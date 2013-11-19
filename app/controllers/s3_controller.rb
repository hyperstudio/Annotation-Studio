class S3Controller < ApplicationController  
  include AWS::S3

  def check_duplicate_s3_object(new_params)
    if AWS::S3::S3Object.exists? new_params[:filename], new_params[:bucket]
      raise S3File::S3FileExistsError
    end
  end

  def create_new_s3_object(new_params)
      AWS::S3::S3Object.store(new_params[:filename], 
        new_params[:data], new_params[:bucket], :access => :public_read)  
  end
end
