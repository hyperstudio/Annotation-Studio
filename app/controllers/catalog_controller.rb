# support for MEL catalog entries
require 'melcatalog'

class CatalogController < ApplicationController
  before_filter :authenticate_user!

  def index

    # default search definitions
    @search_term = ""
    @search_types = []
    @search_results = {}
    @onlyimages = false

    # do we need to modify the defaults...
    @search_term = params[:term] unless params[:term].nil?
    types = []
    types = params[:types].split( "," ) unless params[:types].nil?
    @search_types << :person if types.include? 'people'
    @search_types << :artwork if types.include? 'artwork'
    @search_types = [:person, :artwork ] if @search_types.empty?
    @onlyimages = true if params[:onlyimages].nil? == false && params[:onlyimages] == 'true'

    # do the search, metadata only
    @search_results = Melcatalog.search( params[:term], Melcatalog.configuration.default_result_limit, @search_types ) unless @search_term.empty?

    render "catalog/index", :layout => false
  end

  def image

    result = Melcatalog.get( params[:eid] )
    if result && result[:person]
      # setup the data as appropriate
       render "catalog/image", :layout => false
    elsif result && result[:artwork]
      # setup the data as appropriate
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
