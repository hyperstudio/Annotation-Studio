module CatalogHelper

  def image_display( image )
    if has_image( image )
      "#{image_tag image}"
    else
      "No image available"
    end
  end

  def has_image( image )
    return image.end_with?( 'missing.png' ) == false
  end
end
