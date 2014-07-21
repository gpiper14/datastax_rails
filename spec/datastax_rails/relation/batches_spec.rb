require 'spec_helper'

describe DatastaxRails::Relation do
  before(:each) do
    @relation = DatastaxRails::Relation.new(Hobby, 'hobbies')
    ('a'..'l').each_with_index do |letter, idx|
      Hobby.create(name: letter)
      sleep(1) if idx % 5 == 4 # Performance hack
    end
    Hobby.commit_solr
  end

  %w(cassandra solr).each do |access_method|
    describe '#find_each' do
      it "returns each record one at a time with #{access_method}" do
        sleep(1)
        missed_hobbies = ('a'..'l').to_a
        @relation.send('with_' + access_method).find_each(batch_size: 5) do |hobby|
          missed_hobbies.delete_if { |h| h == hobby.name }
        end
        expect(missed_hobbies).to be_empty
      end
    end

    describe '#find_in_batches' do
      it "returns records in batches of the given size with #{access_method}" do
        count = 12
        @relation.send('with_' + access_method).find_in_batches(batch_size: 5) do |batch|
          expect(batch.size).to be <= 5
          count -= batch.size
        end
        expect(count).to eq(0)
      end
    end
  end
end
