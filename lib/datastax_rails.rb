require 'active_support/all'
require 'blankslate'
require 'schema_migration'

# Welcome to DatastaxRails.  DatastaxRails::Base is probably a good place to start.
module DatastaxRails
  extend ActiveSupport::Autoload
  
  autoload :Associations
  autoload :AttributeAssignment
  autoload :AttributeMethods
  autoload :Base
  autoload :Batches
  autoload :Callbacks
  autoload :CassandraOnlyModel
  autoload :Column
  autoload :Collection
  autoload :Connection
  
  autoload_under 'connection' do
    autoload :StatementCache
  end
  
  autoload :Cql
  autoload :DynamicModel
  autoload :GroupedCollection
  autoload :Index
  autoload :Inheritance
  autoload :PayloadModel
  autoload :Persistence
  autoload :Reflection
  autoload :Relation
  
  autoload_under 'relation' do
    autoload :FinderMethods
    autoload :ModificationMethods
    autoload :SearchMethods
    autoload :SpawnMethods
    autoload :StatsMethods
    autoload :Batches
    autoload :FacetMethods
  end
  
  autoload :RSolrClientWrapper, 'datastax_rails/rsolr_client_wrapper'
  autoload :Schema
  autoload :Scoping
  autoload :Serialization
  autoload :Timestamps
  autoload_under 'util' do
    autoload :SolrRepair
  end
  autoload :Validations
  autoload :Version
  autoload :WideStorageModel
  
  module AttributeMethods
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Dirty
      autoload :PrimaryKey
      autoload :Read
      autoload :Typecasting
      autoload :Write
    end
  end
  
  module Scoping
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Named
      autoload :Default
    end
  end

  module Tasks
    extend ActiveSupport::Autoload
    autoload :Keyspace
    autoload :ColumnFamily
  end
  
  module Types
    extend ActiveSupport::Autoload
    
    eager_autoload do
      autoload :DirtyCollection
      autoload :DynamicList
      autoload :DynamicSet
      autoload :DynamicMap
    end
  end
end

require 'datastax_rails/railtie' if defined?(Rails)
require 'datastax_rails/errors'
require 'cql-rb_extensions'

ActiveSupport.run_load_hooks(:datastax_rails, DatastaxRails::Base)
