require "melcatalog/version"
require "configuration"

#require 'rest_client'

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
      entity_types = Melcatalog.configuration.default_entity_types if entity_types.empty?
      search_fields = Melcatalog.configuration.default_searchable_fields if search_fields.empty?

      #response = RestClient.get Melcatalog.configuration.service_endpoint
      response = []
      response << fake_text( 1 ) unless entity_types.index( :text ).nil?
      response << fake_text( 2 ) unless entity_types.index( :text ).nil?

      response << fake_person( 1 ) unless entity_types.index( :person ).nil?
      response << fake_person( 2 ) unless entity_types.index( :person ).nil?

      response << fake_artwork( 1 ) unless entity_types.index( :artwork ).nil?
      response << fake_artwork( 2 ) unless entity_types.index( :artwork ).nil?

      return response
   end

   #
   # get the entity specified by the provided uid
   #
   # eid       - an opaque entity identifier. This is provided when browsing/searching and is assumed to be static/persistent
   # content   - return full content or just metadata
   #
   def self.get( eid, content = true )
      return [ fake_text( 1 ) ]
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
      #results = []self.search( "*", false, Melcatalog.configuration.default_result_limit, [ :text ] )
      results = []
      (1..5).each { |num|
         results << self.fake_text( num )
      }
      return results
   end

   #
   # helper to get all the metadata for people entities
   #
   def self.people( )
      #results = self.search( "*", false, Melcatalog.configuration.default_result_limit, [ :person ] )
      results = []
      (1..15).each { |num|
         results << self.fake_person( num )
      }
      return results
   end

   #
   # helper to get all the metadata for artwork entities
   #
   def self.artwork( )
      #results = self.search( "*", false, Melcatalog.configuration.default_result_limit, [ :artwork ] )
      results = []
      (1..10).each { |num|
        results << self.fake_artwork( num )
      }
      return results
   end

  private

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
