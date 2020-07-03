# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /graphql' do
  it 'executes the given query or mutation' do
    stub_schema_execute

    variables = { 'myVariables' => 'test' }
    query = 'someLongQuery(input: { id: ID } { users { id name } })'
    operation_name = 'signIn'

    post api_path(
      format: :json,
      variables: variables.to_json,
      query: query,
      operationName: operation_name
    )

    expect(LibraryApiSchema).to have_received(:execute).with(
      query,
      variables: variables,
      context: { current_user: nil, current_ability: nil },
      operation_name: operation_name
    )

    expect(json_body).to eq('success' => true)
  end

  it 'sets the current_user context' do
    user = create(:user)
    stub_schema_execute
    sign_in_user(user)
    new_ability = Ability.new(user)
    allow(Ability).to receive(:new).and_return(new_ability)

    post api_path(format: :json)

    expect(LibraryApiSchema).to have_received(:execute).with(
      nil,
      variables: {},
      context: { current_user: user, current_ability: Ability.new(user) },
      operation_name: nil
    )
    expect(json_body).to eq('success' => true)
  end

  it 'returns an exception if record not found' do
    user = create(:user)
    sign_in_user(user)
    new_ability = Ability.new(user)
    allow(Ability).to receive(:new).and_return(new_ability)

    query = "{category(id: 33){\n    id\n    name }}"
    post api_path(format: :json, query: query)

    expect(json_body[:data][:category]).to eq(nil)
    expect(json_body[:errors]).to eq(['Couldn\'t find Category with \'id\'=33'])
  end

  # ...

  def stub_schema_execute
    allow(LibraryApiSchema).
      to receive(:execute).and_return(success: true)
  end

  def json_body
    json = JSON.parse(response.body)
    json.is_a?(Hash) ? json.with_indifferent_access : json # could be an array
  end
end
