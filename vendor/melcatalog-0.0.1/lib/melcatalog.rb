require "melcatalog/version"
require "configuration"
require 'json'
require 'rest_client'

module Melcatalog

   class << self
     attr_accessor :configuration
   end

   def self.configuration
     @configuration ||= Configuration.new
   end

   def self.configure
     yield(configuration)
   end

   #
   # search the MEL catalogue and return an array of results
   #
   # term          - the term to search for.
   # content       - return full content or just metadata.
   # limit         - the maximum number of results to return.
   # entity_types  - include just these entity types. If empty then include all entity types.
   # search_fields - just search these fields for the specified term. If empty then all fields are searched.
   #
   def self.search( term, limit = Melcatalog.configuration.default_result_limit, entity_types = [], search_fields = [] )

      # handle defaults...
      #entity_types = Melcatalog.configuration.default_entity_types if entity_types.empty?
      #search_fields = Melcatalog.configuration.default_searchable_fields if search_fields.empty?

      results = {}
      term = "%" if term.empty?

      entity_request = self.request_entity_types( entity_types )
      entity_request = "&entry_types=#{entity_request}" unless entity_request.empty?

      request = "#{Melcatalog.configuration.service_endpoint}/entries?search_term=#{term}#{entity_request}&limit=#{limit}"
      return self.transform self.rest_get request
   end

   #
   # get the entity specified by the provided uid
   #
   # eid       - an opaque entity identifier. This is provided when browsing/searching and is assumed to be static/persistent
   # content   - return full content or just metadata
   #
   def self.get( eid, content = true )
     request = "#{Melcatalog.configuration.service_endpoint}/entries/#{eid}"
     return self.transform self.rest_get request
   end

   #
   # get a hash representing the AAT hierarchy of all our content
   #
   def self.aat_hierarchy( )
     request = "#{Melcatalog.configuration.service_endpoint}/tags"
     return self.rest_get request
   end

   #
   # helper to get all the metadata for text entities
   #
   def self.texts( limit = Melcatalog.configuration.default_result_limit )
      request = "#{Melcatalog.configuration.service_endpoint}/texts?limit=#{limit}"
      results = self.rest_get request
      return { :text => results }
   end

   #
   # helper to get all the metadata for people entities
   #
   def self.people( limit = Melcatalog.configuration.default_result_limit )
     request = "#{Melcatalog.configuration.service_endpoint}/people?limit=#{limit}"
     results = self.rest_get request
     return { :person => results }
   end

   #
   # helper to get all the metadata for artwork entities
   #
   def self.artwork( limit = Melcatalog.configuration.default_result_limit )
     request = "#{Melcatalog.configuration.service_endpoint}/artworks?limit=#{limit}"
     results = self.rest_get request
     return { :artwork => results }
   end

  private

  def self.rest_get( request )
    results = {}
    begin
      response = RestClient.get URI.escape request
      if response.code == 200
        results = JSON.parse response
      end
    rescue => e
      puts request
      puts e
    end
    return results
  end

  def self.transform( response )
    result = {}
    result[:person] = response['people'] unless response['people'].nil?
    result[:artwork] = response['artworks'] unless response['artworks'].nil?
    result[:text] = response['texts'] unless response['texts'].nil?
    return result
  end

  def self.request_entity_types( entity_types )
     result = ""
     entity_types.each do | entity |
       case entity
         when :text
           result = "#{result}," unless result.empty?
           result << "texts"
         when :person
           result = "#{result}," unless result.empty?
           result << "people"
         when :artwork
           result = "#{result}," unless result.empty?
           result << "artworks"
         else
           puts "Unknown entry type #{entity}"
       end
     end

     return result
  end

end
