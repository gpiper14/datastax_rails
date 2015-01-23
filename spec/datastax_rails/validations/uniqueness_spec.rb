require 'spec_helper'

class InvalidValidationModel < DatastaxRails::Base
  text :text_field

  validates :text_field, uniqueness: true
end

describe DatastaxRails::Base do
  describe 'uniqueness validation' do
    it 'should validate uniqueness' do
      Person.commit_solr
      Person.create!(name: 'Jason')
      Person.commit_solr
      Person.commit_solr
      person = Person.new(name: 'Jason')
      expect(person).not_to be_valid
      person.name = 'John'
      expect(person).to be_valid
    end

    it 'should allow an update to a model without triggering a uniqueness error' do
      Person.commit_solr
      p = Person.create!(name: 'Jason', birthdate: Date.strptime('10/19/1985', '%m/%d/%Y'))
      Person.commit_solr
      p.birthdate = Date.strptime('10/19/1980', '%m/%d/%Y')
      p.save!
    end

    it 'should not break when negative numbers are entered' do
      j = Job.new(title: 'Mouseketeer', position_number: -1)
      expect(j).to be_valid
    end

    it 'should not enforce uniqueness of blanks if specified' do
      Job.create!(title: 'Engineer')
      Job.commit_solr
      j = Job.new(title: 'Analyst')
      expect(j).to be_valid
    end

    it 'should enforce uniqueness of blanks if not instructed otherwise' do
      Boat.create!(name: nil)
      Boat.commit_solr
      b = Boat.new
      expect(b).not_to be_valid
    end

    it 'does not allow uniqueness validations on tokenized fields' do
      expect { InvalidValidationModel.new.valid? }.to raise_exception(DatastaxRails::InvalidValidationError)
    end

    it 'checks the untokenized version of the attribute' do
      Person.create!(name: 'John Doe')
      Person.commit_solr
      person = Person.new(name: 'John Doe')
      expect(person).not_to be_valid
      person = Person.new(name: 'John')
      expect(person).to be_valid
    end
  end
end
