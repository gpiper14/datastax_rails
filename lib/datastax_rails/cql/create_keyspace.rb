module DatastaxRails
  module Cql
    # CQL Generation for CREATE KEYSPACE
    class CreateKeyspace < Base
      def initialize(ks_name)
        @ks_name = ks_name
        @strategy_options = {}
      end

      def strategy_class(sc)
        @strategy_class = sc
        self
      end

      def strategy_options(so)
        @strategy_options.merge!(so)
        self
      end

      def to_cql
        stmt = "CREATE KEYSPACE #{@ks_name} WITH REPLICATION = {'class' : '#{@strategy_class}'"

        @strategy_options.each do |key, value|
          stmt << ", '#{key}' : '#{value}'"
        end
        stmt << '}'
        stmt
      end
    end
  end
end
