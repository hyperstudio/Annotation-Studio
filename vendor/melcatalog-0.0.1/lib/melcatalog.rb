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
   def self.search( term, content = true, limit = Melcatalog.configuration.default_result_limit, entity_types = [], search_fields = [] )

      # handle defaults...
      #entity_types = Melcatalog.configuration.default_entity_types if entity_types.empty?
      #search_fields = Melcatalog.configuration.default_searchable_fields if search_fields.empty?

      results = []
      term = "%" if term.empty?

      entity_request = self.request_entity_types( entity_types )
      entity_request = "&entry_types=#{entity_request}" unless entity_request.empty?
      request = URI.escape "#{Melcatalog.configuration.service_endpoint}/entries?search_term=#{term}#{entity_request}"

      begin
         response = RestClient.get request
         if response.code == 200
           results = self.transform JSON.parse response
         end
      rescue => e
        puts request
        puts e
      end

      return results
   end

   #
   # get the entity specified by the provided uid
   #
   # eid       - an opaque entity identifier. This is provided when browsing/searching and is assumed to be static/persistent
   # content   - return full content or just metadata
   #
   def self.get( eid, content = true )

     request = URI.escape "#{Melcatalog.configuration.service_endpoint}/entries/#{eid}"
     begin
        response = RestClient.get request
        if response.code == 200
           puts response
        end
     rescue => e
       puts request
       puts e
     end
     return {}
   end

   #
   # get a hash representing the AAT hiararchy of all our content
   #
   def self.aat_hirararchy( )
      return [ { :text => 'texts', :nodes => [ :text => 'sub classification', :nodes => [ { :text => 'an entity title', :eid => '123456' }] ] },
               { :text => 'people', :nodes => [ ] },
               { :text => 'artworks', :nodes => [ ] }
             ]
   end

   #
   # helper to get all the metadata for text entities
   #
   def self.texts( )
      results = self.search( "", false, Melcatalog.configuration.default_result_limit, [ :text ] )
      return results
   end

   #
   # helper to get all the metadata for people entities
   #
   def self.people( )
      results = self.search( "", false, Melcatalog.configuration.default_result_limit, [ :person ] )
      return results
   end

   #
   # helper to get all the metadata for artwork entities
   #
   def self.artwork( )
      results = self.search( "", false, Melcatalog.configuration.default_result_limit, [ :artwork ] )
      return results
   end

  private

  def self.transform( response )
    result = {}
    result[:person] = self.transform_people( response['people'] ) unless response['people'].nil?
    result[:artwork] = self.transform_artworks( response['artworks'] ) unless response['artworks'].nil?
    result[:text] = self.transform_texts( response['texts'] ) unless response['texts'].nil?
    return result
  end

  def self.transform_people( entries )
     result = []
     entries.each do | entry |
       work = {}
       work[:eid] = entry['id'].to_s unless entry['id'].nil?
       work[:name] = entry['name'] unless entry['name'].nil?
       result << work
     end
     return result
  end

  def self.transform_artworks( entries )
    result = []
    entries.each do | entry |
      work = {}
      work[:eid] = entry['id'].to_s unless entry['id'].nil?
      work[:artist] = entry['artist'] unless entry['artist'].nil?
      work[:title] = entry['title'] unless entry['title'].nil?

      result << work
    end
    return result
  end

  def self.transform_texts( entries )
    result = []
    entries.each do | entry |
       work = {}
       work[:eid] = entry['id'].to_s unless entry['id'].nil?
       work[:title] = entry['name'] unless entry['name'].nil?
       work[:author] = entry['author'] unless entry['author'].nil?
       work[:text] = entry['content'] unless entry['content'].nil?
       result << work
    end
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

  def self.fake_text( number )
    entry = {}
    entry[:title] = "Title for text # #{number}"
    entry[:author] = "Author for text # #{number}"
    entry[:edition] = "Edition for text # #{number}"
    entry[:publisher] = "Publisher for text # #{number}"
    entry[:pubdate] = "Publication Date for text # #{number}"
    entry[:source] = "Source for text # #{number}"
    entry[:rights] = "Rights for text # #{number}"
    entry[:text] = "All the text for text # #{number}"
    entry[:type] = :text
    return entry
  end

  def self.fake_person( number )
    entry = {}
    entry[:title] = "Title for person # #{number}"
    entry[:type] = :person
    return entry
  end

  def self.fake_artwork( number )
    entry = {}
    entry[:title] = "Title for artwork # #{number}"
    entry[:type] = :artwork
    return entry
  end

end
