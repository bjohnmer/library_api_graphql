require 'rails_helper'

RSpec.describe Author, type: :model do
  subject(:author) { create(:author) }

  describe 'associations' do
    it { is_expected.to have_many(:author_books) }
    it { is_expected.to have_many(:books) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:yob) }
    it { is_expected.to validate_inclusion_of(:is_alive).in_array([true, false]) }
  end

  describe '#full_name' do
    it 'returns the full name' do
      expect(subject.full_name).to eq("#{subject.first_name} #{subject.last_name}")
    end
  end
end
