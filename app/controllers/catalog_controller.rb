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
    @search_types << :person if types.include? 'people'
    @search_types << :artwork if types.include? 'artwork'
    @search_types << :text if types.include? 'texts'
    @onlyimages = true if params[:onlyimages].nil? == false && params[:onlyimages] == 'true'

    # do the search, metadata only
    status, @search_results = Melcatalog.search( @search_term, @search_tags, @search_fields, @search_types, Melcatalog.configuration.default_result_limit ) unless ( @search_term.empty? && @search_tags.empty? )

    # I hate to do this... will pass image only constraint to catalog later...
    # TODO
    if @onlyimages == true
      @search_results[:person].delete_if { |entry| has_images( entry[ 'images'] ) == false } if @search_results[:person].nil? == false
      @search_results[:artwork].delete_if { |entry| has_images( entry[ 'images'] ) == false } if @search_results[:artwork].nil? == false
      @search_results[:text].delete_if { |entry| has_images( entry[ 'images'] ) == false } if @search_results[:text].nil? == false
    end

    render "catalog/index", :layout => false
  end

  def image

    status, result = Melcatalog.get( params[:eid], 'stripxml' )

    entry = nil
    if status == 200 && result && result[:person]
       entry = result[:person][ 0 ]
    elsif status == 200 && result && result[:artwork]
       entry = result[:artwork][ 0 ]
    elsif status == 200 && result && result[:text]
       entry = result[:text][ 0 ]
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
    if status == 200 && result && result[:person]
      entry = result[:person][ 0 ]
      title = "Person Information"
      fieldlist = ['forename', 'surname', 'additional_name_info', 'birth', 'death', 'role', 'nationality', 'education', 'see_also']
    elsif status == 200 && result && result[:artwork]
       entry = result[:artwork][ 0 ]
       title = "Artwork Information"
       fieldlist = ['artist', 'artist_national_origin', 'publication', 'technique',
                    'material', 'location_of_print', 'genre', 'subject', 'viewed', 'permissions',
                    'owned_acquired_borrowed', 'explicit_reference', 'associated_reference', 'see_also']
    elsif status == 200 && result && result[:text]
      entry = result[:text][ 0 ]
      title = "Text Information"
      fieldlist = ['author', 'version', 'manuscript', 'edition', 'publisher', 'place_of_publication', 'publication_date', 'permissions', 'copyright', 'credit_line', 'see_also', 'content_type', 'content']
    end

    if entry.nil?
      render :file => 'public/404.html', :status => :not_found, :layout => false
    else
      render "catalog/reference", :locals => { entry: entry, title: title, fieldlist: fieldlist }, :layout => false
    end

  end
end
