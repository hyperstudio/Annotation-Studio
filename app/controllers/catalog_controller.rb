# support for MEL catalog entries
require 'melcatalog'

class CatalogController < ApplicationController
  before_filter :authenticate_user!

  def index

    # default search definitions
    @search_term = ""
    @search_types = []
    @search_results = []

    # do we need to modify the defaults...
    @search_term = params[:term] unless params[:term].nil?
    types = []
    types = params[:types].split( "," ) unless params[:types].nil?
    @search_types << :person if types.include? 'people'
    @search_types << :artwork if types.include? 'artwork'

    # do the search, metadata only
    @search_results = Melcatalog.search( params[:term], false, Melcatalog.configuration.default_result_limit, @search_types ) unless @search_term.empty?

    render "catalog/index", :layout => false
  end

  #def show
  #end
end
