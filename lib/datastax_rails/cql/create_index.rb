module DatastaxRails
  module Cql
    # CQL generation for CREATE INDEX
    class CreateIndex < Base
      def initialize(index_name = nil)
        @cf_name = nil
        @column = nil
        @index_name = index_name
      end

      def on(cf_name)
        @cf_name = cf_name
        self
      end

      def column(column)
        @column = column
        self
      end

      def to_cql
        "CREATE INDEX #{@index_name} ON #{@cf_name} (#{@column})"
      end
    end
  end
end
