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

  def image_or_nothing( images, type )
    if has_images( images )
      image_tag( images[ 0 ][type], :class => "img-responsive" )
    end
  end

  def thumbnail_or_nothing( images )
    image_or_nothing( images, 'image_thumb' )
  end

  def thumbnail_url( images )
    if has_images( images )
      return( images[ 0 ]['image_thumb'] )
    else
      return( '' )
    end
  end

  def has_images( images )
    return( ( images.nil? == false ) && ( images.empty? == false ) )
  end
end
