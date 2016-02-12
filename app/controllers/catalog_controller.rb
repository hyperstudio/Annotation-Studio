# support for MEL catalog entries
require 'melcatalog'

class CatalogController < ApplicationController

  include CatalogHelper

  before_filter :authenticate_user!

  def index

    # default search definitions
    @search_term = ""
    @search_tags = ""
    @search_fields = []
    @search_types = []
    @search_results = {}
    @onlyimages = false

    # do we need to modify the defaults...
    @search_term = params[:term] unless params[:term].nil?
    @search_tags = params[:search_tags] unless params[:search_tags].nil?

    types = []
    types = params[:types].split( "," ) unless params[:types].nil?
    @search_types << :artwork if types.include? 'artwork'
    @search_types << :event if types.include? 'events'
    @search_types << :person if types.include? 'people'
    @search_types << :place if types.include? 'places'
    @search_types << :text if types.include? 'texts'
    @onlyimages = true if params[:onlyimages].nil? == false && params[:onlyimages] == 'true'

    # do the search, metadata only
    status, @search_results = Melcatalog.search( @search_term, @search_tags, @search_fields, @search_types, Melcatalog.configuration.default_result_limit ) unless ( @search_term.empty? && @search_tags.empty? )

    # I hate to do this... will pass image only constraint to catalog later...
    # TODO
    if @onlyimages == true
      @search_results[:artwork].delete_if { |entry| has_images( entry[ 'images'] ) == false } if @search_results[:artwork].nil? == false
      @search_results[:event].delete_if { |entry| has_images( entry[ 'images'] ) == false } if @search_results[:event].nil? == false
      @search_results[:person].delete_if { |entry| has_images( entry[ 'images'] ) == false } if @search_results[:person].nil? == false
      @search_results[:place].delete_if { |entry| has_images( entry[ 'images'] ) == false } if @search_results[:place].nil? == false
      @search_results[:text].delete_if { |entry| has_images( entry[ 'images'] ) == false } if @search_results[:text].nil? == false
    end

    render "catalog/index", :layout => false
  end

  def image

    status, result = Melcatalog.get( params[:eid], 'stripxml' )

    entry = nil
    if status == 200 && result
       entry = result[:artwork][ 0 ] if result[:artwork]
       entry = result[:event][ 0 ] if result[:event]
       entry = result[:person][ 0 ] if result[:person]
       entry = result[:place][ 0 ] if result[:place]
       entry = result[:text][ 0 ] if result[:text]
    end

    if entry.nil?
      render :file => 'public/404.html', :status => :not_found, :layout => false
    else
      render "catalog/image", :locals => { entry: entry }, :layout => false
    end

  end

  def reference

    status, result = Melcatalog.get( params[:eid], 'stripxml' )

    entry = nil
    if status == 200 && result
      if result[:artwork]
         entry = result[:artwork][ 0 ]
         title = "Artwork Information"
         fieldlist = ['artist', 'artist_national_origin', 'publication', 'technique',
                      'material', 'location_of_print', 'genre', 'subject', 'viewed', 'permissions',
                      'owned_acquired_borrowed', 'explicit_reference', 'associated_reference', 'see_also', 'references']
      elsif result[:event]
        entry = result[:event][ 0 ]
        title = "Event Information"
        fieldlist = ['name', 'alternate_name', 'event_type', 'event_subtype', 'location', 'date_type', 'from_date', 'to_date', 'event_date',
                     'see_also', 'references']
      elsif result[:person]
         entry = result[:person][ 0 ]
         title = "Person Information"
         fieldlist = ['authoritative_name', 'display_name', 'forename', 'surname', 'person_type', 'description', 'birth', 'death', 'occupation',
                      'affiliation', 'nationality', 'cultural_context', 'see_also', 'references']
      elsif result[:place]
         entry = result[:place][ 0 ]
         title = "Place Information"
         fieldlist = ['name', 'name_type', 'alternate_name', 'place_type', 'latitude', 'longitude',
                      'note', 'see_also', 'references']
      elsif result[:text]
         entry = result[:text][ 0 ]
         title = "Text Information"
         fieldlist = ['author', 'version', 'manuscript', 'edition', 'publisher', 'place_of_publication', 'publication_date', 'permissions',
                      'copyright', 'credit_line', 'see_also', 'content_type', 'references', 'content']
      end
    end

    if entry.nil?
      render :file => 'public/404.html', :status => :not_found, :layout => false
    else
      render "catalog/reference", :locals => { entry: entry, title: title, fieldlist: fieldlist }, :layout => false
    end

  end
end
