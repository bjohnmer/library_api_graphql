require 'rails_helper'

RSpec.describe Book, type: :model do
  subject(:book) { create(:book) }

  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:author_books) }
    it { is_expected.to have_many(:authors).through(:author_books) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:yop) }
    it { is_expected.to validate_presence_of(:category) }
  end
end
