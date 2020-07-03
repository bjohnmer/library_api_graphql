require 'rails_helper'

RSpec.describe AuthorBook, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:book) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:book) }
    it { is_expected.to validate_presence_of(:author) }
  end
end
