# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /graphql' do

  describe 'sign_out' do
    it 'responses and error if current_user has no permissions' do
      user = create(:user)
      sign_in_user(user)

      result = GqlSupport.gql_query(
        query: mutation_query,
        context: { current_user: user, current_ability: Ability.new(user) }
      ).to_h.deep_symbolize_keys

      expect(result[:data][:signOut]).to eq(true)
      expect(result[:errors].present?).to eq(false)
    end
  end

  def mutation_query
    <<~GQL
      mutation{
        signOut
      }
    GQL
  end
end
