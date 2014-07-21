require 'spec_helper'

describe DatastaxRails::Schema::Migrator do
  subject do
    DatastaxRails::Schema::Migrator.new('datastax_rails_test').tap { |m| m.verbose = false }
  end

  describe 'payload models' do
    context 'when column family exists' do
      before(:each) do
        allow(subject).to receive(:column_family_exists?).and_return(false)
      end

      it 'calls #create_payload_column_family' do
        expect(subject).to receive(:create_cql3_column_family).with(CarPayload)
        subject.migrate_one(CarPayload)
      end
    end

    context 'when column family exists' do
      before(:each) do
        allow(subject).to receive(:column_family_exists?).and_return(true)
      end

      it 'does not call #create_payload_column_family' do
        expect(subject).not_to receive(:create_cql2_column_family).with(CarPayload)
        subject.migrate_one(CarPayload)
      end
    end
  end

  describe 'wide storage models' do
    context 'when column family does not exist' do
      before(:each) do
        allow(subject).to receive(:column_family_exists?).and_return(false)
        allow(subject).to receive(:create_cql3_column_family)
      end

      it 'calls #create_wide_storage_column_family' do
        expect(subject).to receive(:create_cql3_column_family).with(AuditLog)
        subject.migrate_one(AuditLog)
      end

      it 'calls #check_missing_schema' do
        expect(subject).to receive(:check_missing_schema).with(AuditLog).and_return(0)
        subject.migrate_one(AuditLog)
      end
    end

    context 'when column family exists' do
      before(:each) do
        allow(subject).to receive(:column_family_exists?).and_return(true)
      end

      it 'does not call #create_wide_storage_column_family' do
        expect(subject).not_to receive(:create_cql3_column_family).with(AuditLog)
        subject.migrate_one(AuditLog)
      end

      it 'calls #check_missing_schema' do
        expect(subject).to receive(:check_missing_schema).with(AuditLog).and_return(0)
        subject.migrate_one(AuditLog)
      end
    end
  end

  describe 'normal models' do
    it 'calls #check_missing_schema' do
      expect(subject).to receive(:check_missing_schema).with(Person).and_return(0)
      subject.migrate_one(Person)
    end

    context 'force mode on' do
      it 'calls #upload_solr_configuation with force true' do
        expect(subject).to receive(:upload_solr_configuration).with(Person, true).and_return(0)
        subject.migrate_one(Person, true)
      end
    end

    context 'force mode off' do
      it 'calls #upload_solr_configuation with force false' do
        expect(subject).to receive(:upload_solr_configuration).with(Person, false).and_return(0)
        subject.migrate_one(Person, false)
      end
    end
  end
end
