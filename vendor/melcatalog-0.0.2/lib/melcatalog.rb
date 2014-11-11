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
   # search_term   - the term to search for.
   # search_tag    - the tag to search for (defaults to all tags).
   # search_fields - just search these fields for the specified term. If empty then all fields are searched.
   # entity_types  - include just these entity types. If empty then include all entity types.
   # limit         - the maximum number of results to return.
   #
   def self.search( search_term, search_tag = "", search_fields = [], entity_types = [], limit = Melcatalog.configuration.default_result_limit )

      term_request = search_term
      term_request = "&search_term=#{term_request}" unless term_request.empty?

      tag_request = search_tag
      tag_request = "&search_tags=#{tag_request}" unless tag_request.empty?

      field_request = self.build_field_list( search_fields )
      field_request = "&search_fields=#{field_request}" unless field_request.empty?

      entity_request = self.build_entity_list( entity_types )
      entity_request = "&entry_types=#{entity_request}" unless entity_request.empty?

      request = "#{Melcatalog.configuration.service_endpoint}/entries?limit=#{limit}#{term_request}#{field_request}#{tag_request}#{entity_request}"
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
   # get a hash representing the tag hierarchy of all our content
   #
   def self.tag_hierarchy( )
     request = "#{Melcatalog.configuration.service_endpoint}/tags"
     return self.rest_get request
   end

   #
   # helper to get all the metadata for text entities
   #
   def self.texts( limit = Melcatalog.configuration.default_result_limit )
     all_terms = ""
     all_tags = ""
     all_fields = []
     return self.search( all_terms, all_tags, all_fields, [:text], limit )
   end

   #
   # helper to get all the metadata for people entities
   #
   def self.people( limit = Melcatalog.configuration.default_result_limit )
     all_terms = ""
     all_tags = ""
     all_fields = []
     return self.search( all_terms, all_tags, all_fields, [:person], limit )
   end

   #
   # helper to get all the metadata for artwork entities
   #
   def self.artwork( limit = Melcatalog.configuration.default_result_limit )
     all_terms = ""
     all_tags = ""
     all_fields = []
     return self.search( all_terms, all_tags, all_fields, [:artwork], limit )
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

  def self.build_field_list( search_fields )
    result = ""
    result = search_fields.join( "," ) unless ( search_fields.nil? || search_fields.empty? )
    return( result )
  end

  def self.build_entity_list( entity_types )
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
           puts "Unknown entity type #{entity}"
       end
     end

     return result
  end

end
