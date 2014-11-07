module CatalogHelper

  def tagset_display( field )
    return "" if( field.nil? || field.empty? )

    tags = field.split( "|" )
    return field if tags.length == 1

    return( "#{tags[0]}...")
  end

  def image_or_text( image, text = nil )
    if has_image( image )
      image_tag( image, :class => "img-responsive" )
    else
      return text unless text.nil?
      return "No image available"
    end
  end

  def has_image( image )
    return image.end_with?( 'missing.png' ) == false
  end
end
