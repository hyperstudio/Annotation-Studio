require 'net/http'
require 'multi_json'
require "rest-client"
require 'csv'
require "json"

class ApiRequester
    @@api_url = ENV['PROTOCOL']+'//'+ENV['API_URL']

    def self.get_by_uuid(params, token)

        headers = {
          'x-annotator-auth-token': token,
          accept: :json,
          content_type: 'application/json',
          params: params
        }

        response = RestClient.get(@@api_url + '/search', headers)

        case response.code
        when 200
            puts "Got Annotation by UUID"
            return JSON.parse(response)
        when 204
            puts "No content"
            return 0
        else
            puts "GET by UUID Request NOT successful"
            return -1
        end
    end

    def self.search(params, token, to_csv: false)
        url = URI.parse(@@api_url + '/search')
        url.query = URI.encode_www_form(params)
        request = Net::HTTP::Get.new(url)
        # request['accept'] = 'application/json'
        request['accept'] = 'text/csv'
        request['x-annotator-auth-token'] = token
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        if ENV['RAILS_ENV'] == 'development'
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http.ca_file = 'lib/local-data-store.cert'
        end
        if !request.body.nil? 
          puts request.body.to_json # debug
        end
        response = http.request(request)
        if !response.body.nil?
          puts response.body.to_json # debug
          data = MultiJson.load(response.body)
        else
          data = nil
        end
        to_csv == false ? data : CsvGenerator.to_csv(data)
    end

    def self.field(params, token, to_csv: false)
      url = URI.parse(@@api_url + '/field')
      url.query = URI.encode_www_form(params)
      request = Net::HTTP::Get.new(url)
      request['accept'] = 'application/json'
      request['x-annotator-auth-token'] = token
      response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
      data = MultiJson.load(response.body)
  end

    def self.create(annotation, token)
        headers = {
          'x-annotator-auth-token': token,
          accept: :json,
          content_type: 'application/json',
        }

        response = RestClient.post(@@api_url + '/annotations', annotation.to_json, headers)

        case response.code
        when 200
            puts "Annotation POST Request successful"
            return response
        else
            puts "Annotation POST request not successful"
        end

        response
    end

    def self.update(annotation, token)
        headers = {
          'x-annotator-auth-token': token,
          accept: :json,
          content_type: 'application/json',
        }

        # binding.pry

        response = RestClient::Request.execute(:method => :put, :url => @@api_url + '/annotations/' + annotation["id"], :payload => annotation.to_json, :headers => headers, :verify_ssl => false)

        case response.code
        when 200
            puts "Annotation PUT Request successful"
            return response
        else
            puts "Annotation PUT request not successful"
            return response
        end

        # binding.pry
        response

    end
end

class UserIngester
  # Assumptions:
  # - users will use the same email address for all accounts
  # - this will be run as a rake task, and should be repeatable with no risk
  def self.get_users
    @documents = Array.new

    (0..4).to_a.each do |page|
        headers = {
          accept: :json,
          content_type: 'application/json',
        }
        response = RestClient.get("http://dev-rc-distro.pantheonsite.io/editions/api/user.json?page=#{page}", headers)
        @documents << JSON.parse(response)
    end

    return @documents.flatten!
  end
end

class DocumentIngester
  # Assumptions:
  # - users will use the same email address for all accounts
  # - this will be run as a rake task, and should be repeatable with no risk
  def self.get_documents
    headers = {
      accept: :json,
      content_type: 'application/json',
    }
    @documents = Array.new

    (0..1).to_a.each do |page|
      response = RestClient.get("http://dev-rc-distro.pantheonsite.io/editions/api/documents.json?page=#{page}", headers)
      @documents << JSON.parse(response)
    end

    return @documents.flatten!

  end
end

class AnnotationIngester
  # Assumptions:
  # - users will use the same email address for all accounts
  # - this will be run as a rake task, and should be repeatable with no risk
  def self.get_annotations

    @annotations = Array.new

    # (0).to_a.each do |page|
        headers = {
          accept: :json,
          content_type: 'application/json',
        }
        response = RestClient.get("http://dev-rc-distro.pantheonsite.io/annotation/api/annotation_documents.json", headers)
        @annotations << JSON.parse(response)
    # end

    return @annotations.flatten!
  end
end

class CsvGenerator
    @@fields = ['id', 'user', 'username', 'text', 'uri', 'quote',
                'tags', 'ranges', 'groups', 'updated', 'created']

    def self.to_csv(data)
        csv_string = CSV.generate do |csv|
            csv << @@fields
            data.each do |hash|
                csv << hash.values_at(*@@fields)
            end
        end
        csv_string
    end
end
