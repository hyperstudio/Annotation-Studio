require 'spec_helper'

describe Melcatalog do

  before do
    Melcatalog.configure do |config|
      config.service_endpoint = 'http://localhost:4000/api'
    end
  end

  describe '#search' do

     it 'search by term' do
        any_terms = "%"
        results = Melcatalog.search( any_terms )
        fail if results.empty?
     end

     it 'search by tag' do
       no_terms = ""
       tag = "Materials|bitstone"
       results = Melcatalog.search( no_terms, tag )
       fail if results.empty?
     end

     it 'search by type' do
       any_terms = "%"
       any_tags = ""
       all_fields = []

       results = Melcatalog.search( any_terms, any_tags, all_fields, [:text] )
       fail if results.empty?
       fail if results[:text].nil?
       fail if results[:person].nil? == false
       fail if results[:artwork].nil? == false

       results = Melcatalog.search( any_terms, any_tags, all_fields, [:person] )
       fail if results.empty?
       fail if results[:text].nil? == false
       fail if results[:person].nil?
       fail if results[:artwork].nil? == false

       results = Melcatalog.search( any_terms, any_tags, all_fields, [:artwork] )
       fail if results.empty?
       fail if results[:text].nil? == false
       fail if results[:person].nil? == false
       fail if results[:artwork].nil?

     end

     it 'search by type list' do
       any_terms = "%"
       any_tags = ""
       all_fields = []

       results = Melcatalog.search( any_terms, any_tags, all_fields, [:text, :person ] )
       fail if results.empty?
       fail if results[:text].nil?
       fail if results[:person].nil?
       fail if results[:artwork].nil? == false
     end

     it 'limit result count' do
       any_terms = "%"
       any_tags = ""
       all_fields = []
       all_types = []

       max = 1
       results = Melcatalog.search( any_terms, any_tags, all_fields, all_types, max )
       fail if results.empty?

       fail if results[:text].nil? == false && results[:text].size > max
       fail if results[:person].nil? == false && results[:person].size > max
       fail if results[:artwork].nil? == false && results[:artwork].size > max
     end

     it 'image only results' do
        # TODO
     end

  end

  describe '#explicit' do

    it 'get by eid' do

      # get the first text entry by EID
      metadata = Melcatalog.texts(  )
      fail if metadata.empty?
      eid = ""
      eid = metadata[:text][ 0 ]['eid'] unless metadata[:text].nil?
      fail if eid.empty?
      results = Melcatalog.get( eid )
      fail if results.size != 1
      check_texts( results[:text], true )

      # get the first person entry by EID
      metadata = Melcatalog.people(  )
      fail if metadata.empty?
      eid = ""
      eid = metadata[:person][ 0 ]['eid'] unless metadata[:person].nil?
      fail if eid.empty?
      results = Melcatalog.get( eid )
      fail if results.size != 1
      check_people( results[:person], true )

      # get the first artwork entry by EID
      metadata = Melcatalog.artwork(  )
      fail if metadata.empty?
      eid = ""
      eid = metadata[:artwork][ 0 ]['eid'] unless metadata[:artwork].nil?
      fail if eid.empty?
      results = Melcatalog.get( eid )
      fail if results.size != 1
      check_artworks( results[:artwork], true )

    end

  end

  describe '#metadata' do

    it 'get complete tag hierarchy' do

       tagdata = Melcatalog.tags_by_entry_type(  )
       fail if tagdata.empty?
       process_tag_peers( tagdata )

       tagdata = Melcatalog.tags_by_entry_id(  )
       fail if tagdata.empty?
       process_tag_peers( tagdata )

    end

    it 'get tag hierarchy by entry type' do
      tagdata = Melcatalog.tags_by_entry_type( [ 'artwork', 'person' ] )
      fail if tagdata.empty?
      process_tag_peers( tagdata )
    end

    it 'get tag hierarchy by entry id' do

      metadata = Melcatalog.artwork(  )
      fail if metadata.empty?
      must_exist( metadata, :artwork )
      eid_list = metadata[ :artwork ].collect{ | a | a['eid']}

      tagdata = Melcatalog.tags_by_entry_id( eid_list )
      fail if tagdata.empty?
      process_tag_peers( tagdata )
    end

    it 'get empty tag hierarchy' do

      tagdata = Melcatalog.tags_by_entry_type( [ 'bad_type_1', 'bad_type_2' ] )
      fail if tagdata.empty?
      verify_empty_tags( tagdata )

      tagdata = Melcatalog.tags_by_entry_id( [ 'bad_id_1', 'bad_id_2' ] )
      fail if tagdata.empty?
      verify_empty_tags( tagdata )

    end

  end

  describe '#helpers' do

    it 'get texts metadata' do
      metadata = Melcatalog.texts(  )
      fail if metadata.empty?
      must_exist( metadata, :text )
      check_texts( metadata[:text], false )
    end

    it 'get people metadata' do
      metadata = Melcatalog.people(  )
      fail if metadata.empty?
      must_exist( metadata, :person )
      check_people( metadata[:person], false )
    end

    it 'get artwork metadata' do
      metadata = Melcatalog.artwork(  )
      fail if metadata.empty?
      must_exist( metadata, :artwork )
      check_artworks( metadata[:artwork], false )
    end

  end

  private

  def check_texts( entities, contentOk )
    entities.each { | entity |

      must_exist( entity, 'eid' )
      must_exist( entity, 'name' )
      must_exist( entity, 'author' )
      must_exist( entity, 'witnesses' )
      must_exist( entity, 'edition' )
      must_exist( entity, 'publisher' )
      must_exist( entity, 'publication_date' )
      must_exist( entity, 'source' )
      must_exist( entity, 'copyright' )

      must_not_exist( entity, 'content' ) if contentOk == false
      must_exist( entity, 'content' ) if contentOk == true
    }
  end

  def check_people( entities, contentOk )
    entities.each { | entity |
      must_exist( entity, 'eid' )
      must_exist( entity, 'name' )
      must_exist( entity, 'surname' )
      must_exist( entity, 'forename' )
      must_exist( entity, 'role' )
      must_exist( entity, 'additional_name_info' )
      must_exist( entity, 'birth' )
      must_exist( entity, 'death' )
      must_exist( entity, 'nationality' )
      must_exist( entity, 'education' )

      must_exist( entity, 'url' )
      must_exist( entity, 'image_full' )
      must_exist( entity, 'image_medium' )
      must_exist( entity, 'image_thumb' )
    }
  end

  def check_artworks( entities, contentOk )
    entities.each { | entity |
      must_exist( entity, 'eid' )
      must_exist( entity, 'artist' )
      must_exist( entity, 'artist_national_origin' )
      must_exist( entity, 'title' )
      must_exist( entity, 'publication' )
      must_exist( entity, 'technique' )
      must_exist( entity, 'material' )
      must_exist( entity, 'location_of_print' )
      must_exist( entity, 'genre' )
      must_exist( entity, 'subject' )
      must_exist( entity, 'viewed' )
      must_exist( entity, 'permissions' )
      must_exist( entity, 'owned_acquired_borrowed' )
      must_exist( entity, 'explicit_reference' )
      must_exist( entity, 'associated_reference' )

      must_exist( entity, 'url' )
      must_exist( entity, 'image_full' )
      must_exist( entity, 'image_medium' )
      must_exist( entity, 'image_thumb' )
    }
  end

  def process_tag_peers( peers )
    peers.each { | entity |
      must_exist( entity, 'text' )
      must_exist( entity, 'href' )
      process_tag_peers( entity[ 'nodes' ] ) unless entity[ 'nodes' ].nil?
    }
  end

  def verify_empty_tags( tags )
    tags.each { | entity |
      must_exist( entity, 'text' )
      must_exist( entity, 'href' )
      must_exist( entity, 'nodes' )
      fail if entity['nodes'] != nil
    }
  end

  def must_exist( obj, field )
    puts "ERROR: missing required field: #{field}" if obj.has_key?( field ) == false
    fail if obj.has_key?( field ) == false
  end

  def must_not_exist( obj, field )
    puts "ERROR: exists #{field}" if obj.has_key?( field ) == true
    fail if obj.has_key?( field ) == true
  end
end
