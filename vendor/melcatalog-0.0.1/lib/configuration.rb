module Melcatalog

  class Configuration
    attr_accessor :service_endpoint
    attr_accessor :default_result_limit
    attr_accessor :default_entity_types
    attr_accessor :default_searchable_fields

    def initialize

      # service endpoint
      @service_endpoint = 'UNKNOWN'

      # max number of results to return
      @default_result_limit = 1000

      # the default entity types
      @default_entity_types = [ :text, :person, :artwork ]

      # the default searchable fields
      @default_searchable_fields = [ :persname,
                                     :sername,
                                     :forename,
                                     :rolename,
                                     :addname
                                   ]

    end

  end

end