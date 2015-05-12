module Melcatalog

  class Configuration
    attr_accessor :service_endpoint
    attr_accessor :service_key
    attr_accessor :default_result_limit
    attr_accessor :default_entity_types
    attr_accessor :default_searchable_fields

    def initialize

      # service endpoint
      @service_endpoint = 'UNKNOWN'

      # secret key to provide access
      @service_key = ''

      # max number of results to return
      @default_result_limit = 999

    end

  end

end