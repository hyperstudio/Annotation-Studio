require 'spec_helper'

describe Melcatalog do

  before do
    Melcatalog.configure do |config|
      config.service_endpoint = 'http://localhost:4000/api'
      #config.service_endpoint = 'http://mel-catalog.herokuapp.com/api'
    end
  end

  describe '#search' do

     it 'search by term' do
        broad_term = "a"
        status, results = Melcatalog.search( broad_term )
        fail "Bad status" if status != 200
        fail "No search results" if results.empty?
     end

     it 'search by tag' do

       status, tagdata = Melcatalog.tags_by_entry_type( )
       fail "Bad status" if status != 200
       fail "No tag data available" if tagdata.empty?

       tag = ""
       tagdata.each { | t |
         must_exist( t, 'text' )
         must_exist( t, 'nodes' )
         if t['nodes'].nil? == false
            t['nodes'].each do | n |
              must_exist( n, 'text' )
              tag = "#{t['text']}|#{n['text']}"
            end
         end
       }

       fail "No suitable search tags available" if tag.empty?
       no_terms = ""
       status, results = Melcatalog.search( no_terms, tag )
       fail "Bad status" if status != 200
       fail "No search results" if results.empty?
     end

     it 'search by type' do
       all_terms = "%"
       any_tags = ""
       all_fields = []

       status, results = Melcatalog.search( all_terms, any_tags, all_fields, [:artwork] )
       fail "Bad status" if status != 200
       fail "No search results" if results.empty?
       fail "No artwork results" if results[:artwork].nil?
       fail "Unexpected people results" if results[:person].nil? == false
       fail "Unexpected places results" if results[:place].nil? == false
       fail "Unexpected text results" if results[:text].nil? == false

       status, results = Melcatalog.search( all_terms, any_tags, all_fields, [:person] )
       fail "Bad status" if status != 200
       fail "No search results" if results.empty?
       fail "Unexpected artwork results" if results[:artwork].nil? == false
       fail "No people results" if results[:person].nil?
       fail "Unexpected places results" if results[:place].nil? == false
       fail "Unexpected text results" if results[:text].nil? == false

       status, results = Melcatalog.search( all_terms, any_tags, all_fields, [:place] )
       fail "Bad status" if status != 200
       fail "No search results" if results.empty?
       fail "Unexpected artwork results" if results[:artwork].nil? == false
       fail "Unexpected people results" if results[:person].nil? == false
       fail "No places results" if results[:place].nil?
       fail "Unexpected text results" if results[:text].nil? == false

       status, results = Melcatalog.search( all_terms, any_tags, all_fields, [:text] )
       fail "Bad status" if status != 200
       fail "No search results" if results.empty?
       fail "Unexpected artwork results" if results[:artwork].nil? == false
       fail "Unexpected people results" if results[:person].nil? == false
       fail "Unexpected places results" if results[:place].nil? == false
       fail "No text results" if results[:text].nil?

     end

     it 'search by type list' do
       all_terms = "%"
       any_tags = ""
       all_fields = []

       status, results = Melcatalog.search( all_terms, any_tags, all_fields, [:text, :person ] )
       fail "Bad status" if status != 200
       fail "No search results" if results.empty?
       fail "Unexpected artwork results" if results[:artwork].nil? == false
       fail "No people results" if results[:person].nil?
       fail "Unexpected places results" if results[:place].nil? == false
       fail "No text results" if results[:text].nil?
     end

     it 'limit search result count' do
       all_terms = "%"
       any_tags = ""
       all_fields = []
       all_types = []

       max = 1
       status, results = Melcatalog.search( all_terms, any_tags, all_fields, all_types, max )
       fail "Bad status" if status != 200
       fail "No search results" if results.empty?

       fail "Excessive artwork result count" if results[:artwork].nil? == false && results[:artwork].size > max
       fail "Excessive people result count" if results[:person].nil? == false && results[:person].size > max
       fail "Excessive places result count" if results[:place].nil? == false && results[:place].size > max
       fail "Excessive texts result count" if results[:text].nil? == false && results[:text].size > max
     end

     it 'image only results' do
        # TODO
     end

  end

  describe '#explicit' do

    it 'get by eid' do

      # get the first artwork entry by EID
      status, metadata = Melcatalog.artwork( )
      fail "Bad status" if status != 200
      fail "No artwork entries available" if metadata.empty?
      eid = ""
      eid = metadata[:artwork][ 0 ]['eid'] unless metadata[:artwork].nil?
      fail "No artwork entries available" if eid.empty?
      status, results = Melcatalog.get( eid )
      fail "Bad status" if status != 200
      fail "Incorrect result count" if results.size != 1
      check_artworks( results[:artwork], true )

      # get the first person entry by EID
      status, metadata = Melcatalog.people( )
      fail "Bad status" if status != 200
      fail "No people entries available" if metadata.empty?
      eid = ""
      eid = metadata[:person][ 0 ]['eid'] unless metadata[:person].nil?
      fail "No people entries available" if eid.empty?
      status, results = Melcatalog.get( eid )
      fail "Bad status" if status != 200
      fail "Incorrect result count" if results.size != 1
      check_people( results[:person], true )

      # get the first place entry by EID
      status, metadata = Melcatalog.places( )
      fail "Bad status" if status != 200
      fail "No places entries available" if metadata.empty?
      eid = ""
      eid = metadata[:place][ 0 ]['eid'] unless metadata[:place].nil?
      fail "No places entries available" if eid.empty?
      status, results = Melcatalog.get( eid )
      fail "Bad status" if status != 200
      fail "Incorrect result count" if results.size != 1
      check_places( results[:place], true )

      # get the first text entry by EID
      status, metadata = Melcatalog.texts( )
      fail "Bad status" if status != 200
      fail "No text entries available" if metadata.empty?
      eid = ""
      eid = metadata[:text][ 0 ]['eid'] unless metadata[:text].nil?
      fail "No text entries available" if eid.empty?
      status, results = Melcatalog.get( eid )
      fail "Bad status" if status != 200
      fail "Incorrect result count" if results.size != 1
      check_texts( results[:text], true )

    end

    it 'get by eid with good transform' do

      # get the first text entry by EID
      status, metadata = Melcatalog.texts( )
      fail "Bad status" if status != 200
      fail "No text entries available" if metadata.empty?
      eid = ""
      metadata[:text].each do |t|
        if t['content_type'] != 'text/plain'
          eid = t['eid']
          break
        end
      end
      fail "No text entries with transformable document types available" if eid.empty?
      status, results = Melcatalog.get( eid, 'stripxml' )
      fail "Bad status" if status != 200
      fail "Incorrect result count" if results.size != 1
      check_texts( results[:text], true )
    end

    #it 'get by eid with bad transform' do
    #
    #  # get the first text entry by EID
    #  status, metadata = Melcatalog.texts( )
    #  fail "Bad status" if status != 200
    #  fail "No text entries available" if( metadata.empty? || metadata[:text].nil? )
    #  eid = ""
    #  metadata[:text].each do |t|
    #    if t['content_type'] != 'text/plain'
    #      eid = t['eid']
    #      break
    #    end
    #  end
    #  fail "No text entries available" if eid.empty?
    #  status, results = Melcatalog.get( eid, 'badtransform' )
    #  fail "Bad status" if status != 500
    #end

  end

  describe '#metadata' do

    it 'get complete tag hierarchy' do

      status, tagdata = Melcatalog.tags_by_entry_type( )
      fail "Bad status" if status != 200
      fail "No tag data available" if tagdata.empty?
      process_tag_peers( tagdata )

      status, tagdata = Melcatalog.tags_by_entry_id( )
      fail "Bad status" if status != 200
      fail "No tag data available" if tagdata.empty?
      process_tag_peers( tagdata )

    end

    it 'get tag hierarchy by entry type' do

      status, tagdata = Melcatalog.tags_by_entry_type( [ 'artwork', 'person' ] )
      fail "Bad status" if status != 200
      fail "No tag data available" if tagdata.empty?
      process_tag_peers( tagdata )
    end

    it 'get tag hierarchy by entry id' do

      status, metadata = Melcatalog.artwork( )
      fail "Bad status" if status != 200
      fail "No artworks available" if metadata.empty?
      must_exist( metadata, :artwork )
      eid_list = metadata[ :artwork ].collect{ | a | a['eid']}

      status, tagdata = Melcatalog.tags_by_entry_id( eid_list )
      fail "Bad status" if status != 200
      fail "No tag data available" if tagdata.empty?
      process_tag_peers( tagdata )
    end

    it 'get empty tag hierarchy' do

      status, tagdata = Melcatalog.tags_by_entry_type( [ 'bad_type_1', 'bad_type_2' ] )
      fail "Bad status" if status != 200
      fail "No tag data available" if tagdata.empty?
      verify_empty_tags( tagdata )

      status, tagdata = Melcatalog.tags_by_entry_id( [ 'bad_id_1', 'bad_id_2' ] )
      fail "Bad status" if status != 200
      fail "No tag data available" if tagdata.empty?
      verify_empty_tags( tagdata )

    end

    it 'get term scope list' do

      status, scopedata = Melcatalog.term_scopes( )
      fail "Bad status" if status != 200
      fail "No scope data available" if scopedata.empty?
      verify_scopes( scopedata )
    end

    it 'get term list within scope' do

      scope = 'Genre'

      status, termdata = Melcatalog.terms( scope, "" )
      fail "Bad status" if status != 200
      fail "No term data available" if termdata.empty?
      verify_terms( termdata )
    end

    it 'search term list' do

      search = 'art'

      status, termdata = Melcatalog.terms( "", search )
      fail "Bad status" if status != 200
      fail "No term data available" if termdata.empty?
      verify_terms( termdata )
    end

    it 'search term list within scope' do

      scope = 'Genre'
      search = 'art'

      status, termdata = Melcatalog.terms( scope, search )
      fail "Bad status" if status != 200
      fail "No term data available" if termdata.empty?
      verify_terms( termdata )
    end

    it 'limit term result count' do

      max = 5

      status, termdata = Melcatalog.terms( "", "", max )
      fail "Bad status" if status != 200
      fail "No term data available" if termdata.empty?
      fail "Excessive result count" if termdata.size > max
      verify_terms( termdata )
    end

  end

  describe '#helpers' do

    it 'get artwork metadata' do
      status, metadata = Melcatalog.artwork( )
      fail "Bad status" if status != 200
      fail "No artwork available" if metadata.empty?
      must_exist( metadata, :artwork )
      check_artworks( metadata[:artwork], false )
    end

    it 'get people metadata' do
      status, metadata = Melcatalog.people( )
      fail "Bad status" if status != 200
      fail "No people available" if metadata.empty?
      must_exist( metadata, :person )
      check_people( metadata[:person], false )
    end

    it 'get places metadata' do
      status, metadata = Melcatalog.places( )
      fail "Bad status" if status != 200
      fail "No places available" if metadata.empty?
      must_exist( metadata, :place )
      check_places( metadata[:place], false )
    end

    it 'get texts metadata' do
      status, metadata = Melcatalog.texts( )
      fail "Bad status" if status != 200
      fail "No texts available" if metadata.empty?
      must_exist( metadata, :text )
      check_texts( metadata[:text], false )
    end

    it 'connectivity' do
      status = Melcatalog.ping( )
      fail "Bad status" if status != true
    end

  end

  private

  def check_artworks( entities, contentOk )
    entities.each { | entity |
      must_exist( entity, 'eid' )
      must_exist( entity, 'artist' )
      must_exist( entity, 'artist_national_origin' )
      must_exist( entity, 'title' )
      must_exist( entity, 'publication' )
      must_exist( entity, 'location_of_print' )
      must_exist( entity, 'genre' )
      must_exist( entity, 'subject' )
      must_exist( entity, 'viewed' )
      must_exist( entity, 'permissions' )
      must_exist( entity, 'owned_acquired_borrowed' )
      must_exist( entity, 'explicit_reference' )
      must_exist( entity, 'associated_reference' )
      must_exist( entity, 'technique' )
      must_exist( entity, 'material' )
      must_exist( entity, 'see_also' )

      must_exist( entity, 'url' )
      must_exist( entity, 'images' )
    }
  end


  def check_people( entities, contentOk )
    entities.each { | entity |
      must_exist( entity, 'eid' )
      must_exist( entity, 'authoritative_name' )
      must_exist( entity, 'surname' )
      must_exist( entity, 'forename' )
      must_exist( entity, 'type' )
      must_exist( entity, 'occupation' )
      must_exist( entity, 'birth' )
      must_exist( entity, 'death' )
      must_exist( entity, 'nationality' )
      must_exist( entity, 'display_name' )
      must_exist( entity, 'alternate_name' )
      must_exist( entity, 'affiliation' )
      must_exist( entity, 'cultural_context' )
      must_exist( entity, 'description' )
      must_exist( entity, 'see_also' )

      must_exist( entity, 'url' )
      must_exist( entity, 'images' )
    }
  end

  def check_places( entities, contentOk )
    entities.each { | entity |
      must_exist( entity, 'eid' )
      must_exist( entity, 'authoritative_name' )
      must_exist( entity, 'alternate_name' )
      must_exist( entity, 'coordinates' )
      must_exist( entity, 'reference_line' )
      must_exist( entity, 'reference_page' )
      must_exist( entity, 'reference_quote' )
      must_exist( entity, 'reference_title' )
      must_exist( entity, 'type' )
      must_exist( entity, 'see_also' )

      must_exist( entity, 'url' )
      must_exist( entity, 'images' )
    }
  end

  def check_texts( entities, contentOk )
    entities.each { | entity |

      must_exist( entity, 'eid' )
      must_exist( entity, 'name' )
      must_exist( entity, 'author' )
      must_exist( entity, 'edition' )
      must_exist( entity, 'publisher' )
      must_exist( entity, 'publication_date' )
      must_exist( entity, 'copyright' )
      must_exist( entity, 'content_type' )
      must_exist( entity, 'version' )
      must_exist( entity, 'manuscript' )
      must_exist( entity, 'place_of_publication' )
      must_exist( entity, 'permissions' )
      must_exist( entity, 'credit_line' )
      must_exist( entity, 'see_also' )

      must_exist( entity, 'url' )
      must_exist( entity, 'images' )

      must_not_exist( entity, 'content' ) if contentOk == false
      must_exist( entity, 'content' ) if contentOk == true
    }
  end

  def process_tag_peers( peers )
    peers.each { | entity |
      must_exist( entity, 'text' )
      must_exist( entity, 'count' )
      must_exist( entity, 'href' )
      process_tag_peers( entity[ 'nodes' ] ) unless entity[ 'nodes' ].nil?
    }
  end

  def verify_empty_tags( tags )
    tags.each { | entity |
      must_exist( entity, 'text' )
      must_exist( entity, 'count' )
      must_exist( entity, 'href' )
      must_exist( entity, 'nodes' )
      fail "Node tag not empty" if entity['nodes'] != nil
    }
  end

  def verify_scopes( scopes )
    scopes.each { | scope |
      must_exist( scope, 'scope' )
      must_exist( scope, 'source' )
      must_exist( scope, 'count' )
    }
  end

  def verify_terms( terms )
    terms.each { | term |
      must_exist( term, 'term' )
    }
  end

  def must_exist( obj, field )
    #puts "ERROR: missing required field: #{field}" if obj.has_key?( field ) == false
    fail "Missing required field: #{field}" if obj.has_key?( field ) == false
  end

  def must_not_exist( obj, field )
    #puts "ERROR: exists #{field}" if obj.has_key?( field ) == true
    fail "Field #{field} should not exist" if obj.has_key?( field ) == true
  end
end
