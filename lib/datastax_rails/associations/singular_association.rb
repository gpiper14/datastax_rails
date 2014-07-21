module DatastaxRails
  module Associations
    class SingularAssociation < Association #:nodoc:
      # Implements the reader method, e.g. foo.bar for Foo.has_one :bar
      def reader(force_reload = false)
        reload if force_reload || !loaded? || stale_target?
        target
      end

      # Implements the writer method, e.g. foo.items= for Foo.has_many :items
      def writer(record)
        replace(record)
      end

      def create(attributes = {}, options = {}, &block)
        create_record(attributes, options, &block)
      end

      def create!(attributes = {}, options = {}, &block)
        create_record(attributes, options, true, &block)
      end

      def build(attributes = {}, options = {})
        record = build_record(attributes, options)
        yield(record) if block_given?
        set_new_record(record)
        record
      end

      private

      def create_scope
        scoped.scope_for_create.stringify_keys.except('id')
      end

      def find_target
        scoped.first.tap { |record| set_inverse_instance(record) }
      end

      # Implemented by subclasses
      def replace(_record)
        fail NotImplementedError, 'Subclasses must implement a replace(record) method'
      end

      def set_new_record(record) # rubocop:disable Style/AccessorMethodName
        replace(record)
      end

      def create_record(attributes, options, raise_error = false)
        record = build_record(attributes, options)
        yield(record) if block_given?
        saved = record.save
        set_new_record(record)
        fail RecordInvalid.new(record) if !saved && raise_error
        record
      end
    end
  end
end
