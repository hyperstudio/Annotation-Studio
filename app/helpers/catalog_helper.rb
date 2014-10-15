module CatalogHelper

  def image_or_text( image, text = nil )
    if has_image( image )
      image_tag image
    else
      return text unless text.nil?
      return "No image available" if text.nil?
    end
  end

  def has_image( image )
    return image.end_with?( 'missing.png' ) == false
  end
end
