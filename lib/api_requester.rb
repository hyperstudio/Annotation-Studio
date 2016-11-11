require 'net/http'
require 'multi_json'
require "rest-client"
require 'csv'
require "json"

class ApiRequester
    @@api_url = ENV['API_URL']

    def self.search(params, token, to_csv: false)
        url = URI.parse(@@api_url + '/search')
        url.query = URI.encode_www_form(params)
        request = Net::HTTP::Get.new(url)
        # request['accept'] = 'application/json'
        request['accept'] = 'text/csv'
        request['x-annotator-auth-token'] = token
        response = Net::HTTP.start(url.host, url.port) {|http| http.request(request)}
        response.body
        data = MultiJson.load(response.body)
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

        response = RestClient.post(@@api_url + '/annotations', annotation, headers)

        case response.code
        when 200
            puts "Annotation POST Request successful"
            return response
        else
            puts "Annotation POST request not successful"
        end

        response
    end
end

class CoveClient
    @@api_url = ENV['COVE_URL']
    @@password = ENV['COVE_PASSWORD']
    @@username = ENV['COVE_USERNAME']
    @@login_url = "#@@api_url/editions/api/user/login"
    @@action_url = "#@@api_url/editions/api/node"
    @@token_url = "#@@api_url/services/session/token"

    def self.get_unauth_session
        headers = {
          accept: :json,
          content_type: 'application/json',
        }

        response = RestClient.get(@@token_url, headers)
        case response.code
        when 200
            puts "unAuth Request successful."
        else
            puts "unAuth Request unsuccessful."
        end
        return response.body    
    end

    def self.get_cookie(token)
        params = {
          'username': @@username,
          'password': @@password
        }
        headers = {
          'X-CSRF-Token': token,
          accept: :json,
          content_type: 'application/json',
        }
        response = RestClient.post(@@login_url, params, headers)
        cookies = response.cookies
        case response.code
        when 200
            puts "Cookie Request successful"
            return cookies
        else
            puts "Cookie Request not successful"
        end
    end

    def self.get_login_session(cookie)
        headers = {
          cookies: cookie,
          accept: :json,
          content_type: 'application/json',
        }

        response = RestClient.get(@@token_url, headers)

        case response.code
        when 200
            puts "Login GET Request successful"
        else
            puts "Login GET Request not successful"
        end
        return response.body    
    end


    def self.post(token, cookies, document)
        headers = {
          accept: :json,
          content_type: 'application/json',
          'X-CSRF-Token': token,
          'cookies': cookies
        }
        response = RestClient.post(@@action_url, document.to_json, headers)
        case response.code
        when 200
            puts "POST Request successful"
        else
            puts "POST Request not successful"
        end
        return response.body
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
    response = RestClient.get("http://dev-rc-distro.pantheonsite.io/editions/api/documents.json", headers)
    documents = JSON.parse(response)
  end
end

class AnnotationIngester
  # Assumptions: 
  # - users will use the same email address for all accounts
  # - this will be run as a rake task, and should be repeatable with no risk
  def self.get_annotations

    @annotations = Array.new

    (1..12).to_a.each do |page|
        headers = {
          accept: :json,
          content_type: 'application/json',
        }
        response = RestClient.get("http://dev-rc-distro.pantheonsite.io/annotation/api/annotation_documents.json?page=#{page}", headers)
        @annotations << JSON.parse(response)
    end

    return @annotations.flatten!
  end
end

class CsvGenerator
    @@fields = ['id', 'user', 'username', 'text', 'uri', 'quote', 
                'tags', 'ranges', 'subgroups', 'groups', 'updated', 'created']

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
