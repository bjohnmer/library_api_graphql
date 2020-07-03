# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /graphql' do
  let(:user) { create(:user) }

  describe 'sign_in' do
    it 'responses the current_user if sings in' do
      result = GqlSupport.gql_query(
        query: mutation_query,
        context: { current_user: user, current_ability: Ability.new(user) }
      ).to_h.deep_symbolize_keys

      expect(result[:data][:signIn]).not_to be(nil)
      expect(result[:data][:signIn][:firstName]).to eq(user.first_name)
      expect(result[:data][:signIn][:lastName]).to eq(user.last_name)
      expect(result[:data][:signIn][:email]).to eq(user.email)
      expect(result[:data][:signIn][:authenticationToken]).to eq(user.authentication_token)
      expect(result[:errors].present?).to eq(false)
    end

    it 'responses and error if not found' do
      result = GqlSupport.gql_query(
        query: wrong_mutation_query,
        context: { current_user: user, current_ability: Ability.new(user) }
      ).to_h.deep_symbolize_keys

      expect(result[:data][:signIn]).to be(nil)
      expect(result[:errors]).to eq(["User not registered on this application"])
    end
  end

  def mutation_query
    <<~GQL
      mutation {
        signIn(
          email: "#{user.email}",
          password: "testing123"
        ){
          firstName
          lastName
          email
          authenticationToken
        }
      }
    GQL
  end

  def wrong_mutation_query
    <<~GQL
      mutation {
        signIn(
          email: "wrong@email.com",
          password: "testing123"
        ){
          firstName
          lastName
          email
          authenticationToken
        }
      }
    GQL
  end
end
