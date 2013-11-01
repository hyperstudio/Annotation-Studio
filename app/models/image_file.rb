class ImageFile < ActiveRecord::Base
  def self.save(upload)
    name =  upload['image_file'].original_filename
    directory = "app/assets/images/media/images"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['image_file'].read) }
    return File.join("media/images", name)
  end
end