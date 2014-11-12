module CatalogHelper

  def tagset_display( field, truncate = false )
    return "" if( field.nil? || field.empty? )

    # partition into the individual tags
    tags = field.split( "|" )

    # strip metadata
    tags = tags.collect { |t| t.gsub( /^\^/, "" ) }

    # if we only have one tag, return that...
    return tags[0] if tags.length == 1

    return( "#{tags[0]}...") if truncate == true
    return( tags.collect { |t| "'#{t}'" }.join( "," ) )
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
