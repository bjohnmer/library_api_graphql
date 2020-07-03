# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::UserType do
  it "returns the auth token if current user" do
    user = create(:user)
    variables = { 'id': user.gql_id }

    result = GqlSupport.gql_query(
      query: query,
      variables: variables,
      context: { current_user: user, current_ability: Ability.new(user) }
    ).to_h.deep_symbolize_keys

    expect(result.dig(:data, :user, :id)).to eq(user.gql_id)
    expect(result.dig(:data, :user, :authenticationToken)).
      to eq(user.authentication_token)
    expect(result[:errors]).to be_blank
  end

  it "does not return the authenticationToken for non current user" do
    user = create(:user)
    variables = { 'id': user.gql_id }

    result = GqlSupport.gql_query(query: query, variables: variables).
      to_h.deep_symbolize_keys

    expect(result.dig(:data, :user)).to be_nil
    expect(result[:errors]).to_not be_blank
  end

  it "returns authentication token nil if is not the current user" do
    user1 = create(:user)
    user2 = create(:user)
    variables = { 'id': user2.gql_id }

    result = GqlSupport.gql_query(
      query: query,
      variables: variables,
      context: { current_user: user1, current_ability: Ability.new(user1) }
    ).to_h.deep_symbolize_keys

    expect(result.dig(:data, :user, :authentication_token)).to be_nil
  end

  def query
    <<~GQL
      query ($id: String!) {
        user(id: $id) {
          id
          firstName
          lastName
          email
          authenticationToken
        }
      }
    GQL
  end
end
