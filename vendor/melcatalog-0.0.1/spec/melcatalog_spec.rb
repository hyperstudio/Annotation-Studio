require 'spec_helper'

describe Melcatalog do

  before do
    Melcatalog.configure do |config|
      config.service_endpoint = 'http://localhost:4000/api'
    end
  end

  describe '#search' do

     it 'finds by wildcard' do
        term = "%"
        results = Melcatalog.search( term, 1000, false )
        fail if results.empty?

     end

     it 'limit result count' do
       max = 5
       results = Melcatalog.search( '%', max, false )
       fail if results.empty?
       fail if results.size > max
     end

  end

  describe '#explicit' do

    it 'get by eid' do
      results = Melcatalog.search( '%', 1000, false )
      fail if results.empty?

      eid = ""
      eid = results[:text][ 0 ][:eid] unless results[:text].nil?
      eid = results[:person][ 0 ][:eid] unless results[:person].nil?
      eid = results[:artwork][ 0 ][:eid] unless results[:artwork].nil?
      fail if eid.empty?

      results = Melcatalog.get( eid )
      fail if results.empty?
      fail if results.size != 1

      check_texts( results[:text] ) unless results[:text].nil?
      check_people( results[:person] ) unless results[:person].nil?
      check_artworks( results[:artwork] ) unless results[:artwork].nil?

    end

  end

  describe '#metadata' do

    it 'gets AAT hiararchy' do
       metadata = Melcatalog.aat_hirararchy(  )
       fail if metadata.empty?
       process_peers( metadata )
    end

  end

  describe '#helpers' do

    it 'gets texts metadata' do
      metadata = Melcatalog.texts(  )
      fail if metadata.empty?
      must_exist( metadata, :text )
      check_texts( metadata[:text] )
    end

    it 'gets people metadata' do
      metadata = Melcatalog.people(  )
      fail if metadata.empty?
      must_exist( metadata, :person )
      check_people( metadata[:person] )
    end

    it 'gets artwork metadata' do
      metadata = Melcatalog.artwork(  )
      fail if metadata.empty?
      must_exist( metadata, :artwork )
      check_artworks( metadata[:artwork] )
    end

  end

  private

  def check_texts( entities )
    entities.each { | entity |

      must_exist( entity, :eid )
      must_exist( entity, :title )
      must_exist( entity, :author )
      #  must_exist( entity, :edition )
      #  must_exist( entity, :publisher )
      #  must_exist( entity, :pubdate )
      #  must_exist( entity, :source )
      #  must_exist( entity, :rights )
      must_exist( entity, :text )
    }
  end

  def check_people( entities )
    entities.each { | entity |
      must_exist( entity, :eid )
      must_exist( entity, :name )
    }
  end

  def check_artworks( entities )
    entities.each { | entity |
      must_exist( entity, :eid )
      must_exist( entity, :artist )
      must_exist( entity, :title )
    }
  end

  def process_peers( peers )
    peers.each { | entity |
      must_exist( entity, :text )
      process_peers( entity[ :nodes ] ) unless entity[ :nodes ].nil?
      fail if entity[ :eid ].nil? == false && entity[ :eid ].empty?
    }
  end

  def must_exist( obj, sym )
    fail if obj[ sym ].nil?
    fail if obj[ sym ].empty?
  end

end
