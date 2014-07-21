require 'spec_helper'

describe DatastaxRails::Base do
  describe 'Associations' do
    describe 'belongs_to' do
      it 'should set the id when setting the object' do
        person = Person.create(name: 'Jason')
        job = Job.create(title: 'Developer')
        Person.commit_solr
        job.person = person
        expect(job.person_id).to eq(person.id)
      end

      it 'should look up the owning model by id' do
        Job.truncate
        Job.commit_solr
        person = Person.create!(name: 'John')
        Job.create!(title: 'Developer', person_id: person.id)
        Person.commit_solr
        Job.commit_solr
        expect(Job.first.person).to eq(person)
      end
    end
  end
end
