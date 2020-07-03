# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /graphql' do

  describe 'category' do
    it 'gets the given category by its id' do
      categories = create_list(:category, 3)

      user = create(:user)
      sign_in_user(user)

      query = "{category(id: #{categories[0].id}){\n    id\n    name }}"
      post api_path(format: :json, 'query': query)

      expect(json_body[:data]).to include({category:{'id': categories[0].id.to_s, 'name': categories[0].name}})
    end

    it 'response an error if wrong id given' do
      create_list(:category, 3)

      user = create(:user)
      sign_in_user(user)

      query = "{category(id: 33){\n    id\n    name }}"
      post api_path(format: :json, 'query': query)

      expect(json_body[:data][:category]).to eq(nil)
      expect(json_body[:errors]).to eq(['Couldn\'t find Category with \'id\'=33'])
    end
  end

  def json_body
    json = JSON.parse(response.body)
    json.is_a?(Hash) ? json.with_indifferent_access : json # could be an array
  end
end
