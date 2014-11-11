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
    @search_types = [:person, :artwork ] if @search_types.empty?
    @onlyimages = true if params[:onlyimages].nil? == false && params[:onlyimages] == 'true'

    # do the search, metadata only
    @search_results = Melcatalog.search( @search_term, @search_tags, @search_fields, @search_types, Melcatalog.configuration.default_result_limit ) unless ( @search_term.empty? && @search_tags.empty? )

    # I hate to do this... will pass image only constraint to catalog later...
    # TODO
    if @onlyimages == true
      @search_results[:person].delete_if { |entry| has_image( entry[ 'image_full'] ) == false } if @search_results[:person].nil? == false
      @search_results[:artwork].delete_if { |entry| has_image( entry[ 'image_full'] ) == false } if @search_results[:artwork].nil? == false
    end

    render "catalog/index", :layout => false
  end

  def image

    result = Melcatalog.get( params[:eid] )
    if result && result[:person]
       @entry = result[:person][ 0 ]
       render "catalog/image", :layout => false
    elsif result && result[:artwork]
       @entry = result[:artwork][ 0 ]
       render "catalog/image", :layout => false
    else
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def reference

    result = Melcatalog.get( params[:eid] )
    if result && result[:person]
       @entry = result[:person][ 0 ]
       render "catalog/person", :layout => false
    elsif result && result[:artwork]
       @entry = result[:artwork][ 0 ]
       render "catalog/artwork", :layout => false
    else
       render :file => 'public/404.html', :status => :not_found, :layout => false
    end

  end
end
