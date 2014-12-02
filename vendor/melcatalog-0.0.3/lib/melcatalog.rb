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

      status, results = self.rest_get request
      return status, ( self.transform results )
   end

   #
   # get the entity specified by the provided uid
   #
   # eid       - an opaque entity identifier. This is provided when browsing/searching and is assumed to be static/persistent
   # transform - the transform to be applied to content
   #
   def self.get( eid, transform = nil )
     transform = "?transform=#{transform}" unless( transform.nil? || transform.empty? )
     request = "#{Melcatalog.configuration.service_endpoint}/entries/#{eid}#{transform}"

     status, results = self.rest_get request
     return status, ( self.transform results )
   end

   #
   # get a hash representing the tag hierarchy of all content specified by the entry_type_list.
   # if entry_type_list is empty or nil, all entries are returned.
   #
   # entry_type_list - an array of entry types
   #
   def self.tags_by_entry_type( entry_type_list = nil )

     entry_types = ""
     entry_types = "?entry_types=#{entry_type_list.join( "," )}" unless( entry_type_list.nil? || entry_type_list.empty? )

     request = "#{Melcatalog.configuration.service_endpoint}/tags#{entry_types}"

     status, results = self.rest_get request
     return status, results
   end

   #
   # get a hash representing the tag hierarchy of all content specified by the eid_list.
   # if eid_list is empty or nil, all entries are returned
   #
   # eid_list        - an array of eid's
   #
   def self.tags_by_entry_id( eid_list = nil )

     eids = ""
     eids = "?eids=#{eid_list.join( "," )}" unless( eid_list.nil? || eid_list.empty? )

     request = "#{Melcatalog.configuration.service_endpoint}/tags#{eids}"

     status, results = self.rest_get request
     return status, results
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
      return response.code, results
    rescue => e
      puts request
      puts e
      return 500, results
    end
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
