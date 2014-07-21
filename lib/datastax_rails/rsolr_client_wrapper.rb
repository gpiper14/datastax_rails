module DatastaxRails
  # Wraps the RSolr Client class so that exceptions such as Connection Refused can be caught and
  # a new server tried (if one is available)
  class RSolrClientWrapper < BlankSlate
    # @param [RSolr::Client] rsolr the initial RSolr client object to wrap
    def initialize(rsolr, model)
      @rsolr = rsolr
      @model = model
    end

    def method_missing(sym, *args, &block)
      if @rsolr.uri.host != DatastaxRails::Base.current_server
        @rsolr.uri.host = DatastaxRails::Base.current_server
        @rsolr = @model.establish_solr_connection
      end
      @rsolr.__send__(sym, *args, &block)
    rescue Errno::ECONNREFUSED
      tries ||= 3
      tries -= 1
      if tries > 0
        # Force cassandra connection to roll
        DatastaxRails::Cql::Select.new(SchemaMigration, ['digest']).limit(1).execute
        retry
      else
        raise
      end
    end
  end
end
