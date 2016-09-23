require 'net/http'
require 'multi_json'
require 'csv'

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