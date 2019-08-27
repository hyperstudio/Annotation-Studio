require 'spec_helper'

describe ApiController do

  describe "GET 'me'" do
    it "returns http success" do
      get 'me'
      response.should be_success
    end
  end

end
