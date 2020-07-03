# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /graphql' do

  describe 'categories' do
    it 'response with all categories' do
      create_list(:category, 3)

      user = create(:user)
      sign_in_user(user)

      query = "{categories{\n    id\n    name }}"
      post api_path(format: :json, 'query': query)

      expect(json_body[:data][:categories].count).to eq(3)
    end
  end

  def json_body
    json = JSON.parse(response.body)
    json.is_a?(Hash) ? json.with_indifferent_access : json # could be an array
  end
end
