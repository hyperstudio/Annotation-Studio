class CatalogController < ApplicationController
  before_filter :authenticate_user!

  def index
    render "catalog/index", :layout => false
  end

  def show
  end
end
