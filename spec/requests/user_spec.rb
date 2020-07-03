# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /graphql' do
  describe 'user' do
    describe 'resolvers' do
      before do
        user = create(:user)
        sign_in_user(user)
      end

      it 'responses with all users' do
        create_list(:user, 3)

        query = "{users{\n    id\n    firstName }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:users].count).to eq(4)
      end

      it 'responses with all filtered users' do
        create_list(:user, 3)

        query = "{users(filter: { email: \"#{User.first.email}\"}){\n    id\n    firstName }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:users].count).to eq(1)
      end

      it 'responses with all paginated users' do
        create_list(:user, 6)

        query = "{users(first: 3, skip: 2){\n    id\n    firstName }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:users].count).to eq(3)
        expect(json_body[:data][:users].first['id']).to eq(User.third.gql_id)
      end

      it 'responses with the given user by its id' do
        users = create_list(:user, 3)

        query = "{user(id: \"#{users[0].gql_id}\"){\n    id\n    firstName }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data]).to include({user:{'id': users[0].gql_id.to_s, 'firstName': users[0].first_name}})
      end

      it 'response an error if wrong id given' do
        create_list(:user, 3)

        query = "{user(id: \"VXNlci01\"){\n    id\n    firstName }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:user]).to eq(nil)
        expect(json_body[:errors]).to eq(["Couldn't find User with 'id'=5"])
      end
    end

    # describe 'mutations' do
    #   describe 'when creating a user' do
    #     it "creates it if current_user has permissions" do
    #       user = create(:user, :admin)

    #       result = GqlSupport.gql_query(
    #         query: create_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result.dig(:data, :createAuthor)).not_to be(nil)
    #       expect(result.dig(:data, :createAuthor, :first_name)).
    #         not_to be(nil)
    #       expect(result[:errors]).to be_blank
    #     end

    #     it 'responses and error if current_user has no permissions to view' do
    #       user = create(:user)

    #       result = GqlSupport.gql_query(
    #         query: create_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result.dig(:data, :createAuthor)).to be(nil)
    #       expect(result[:errors]).not_to be_blank
    #       expect(result[:errors]).to eq(["You have no permission to create a Author"])
    #     end

    #     it 'responses and error if current_user has no permissions' do
    #       allow(Mutations::Authors::CreateAuthor).to receive(:visible?).and_return(true)
    #       user = create(:user)

    #       result = GqlSupport.gql_query(
    #         query: create_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:data][:createAuthor]).to eq(nil)
    #       expect(result[:errors]).to eq(['You have no permission to create a Author'])
    #     end

    #     it 'responses and error if current_user has no permissions' do
    #       allow(Mutations::Authors::CreateAuthor).to receive(:visible?).and_return(true)
    #       user = create(:user)

    #       result = GqlSupport.gql_query(
    #         query: create_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:data][:createAuthor]).to eq(nil)
    #       expect(result[:errors]).to eq(['You have no permission to create a Author'])
    #     end

    #     it 'responses and error if current_user not signed in' do
    #       user = create(:user, :admin)

    #       result = GqlSupport.gql_query(
    #         query: create_mutation_query,
    #         context: { current_user: nil, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:data][:createAuthor]).to eq(nil)
    #       expect(result[:errors]).to eq(['User not signed in'])
    #     end
    #   end

    #   describe 'when updating a user' do
    #     it "update it if current_user has permissions" do
    #       user = create(:user, :admin)

    #       result = GqlSupport.gql_query(
    #         query: update_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result.dig(:data, :updateAuthor)).not_to be(nil)
    #       expect(result.dig(:data, :updateAuthor, :firstName)).
    #         to eq('New Author Name')
    #       expect(result[:errors]).to be_blank
    #     end

    #     it 'responses and error if current_user has no permissions to view' do
    #       user = create(:user)

    #       result = GqlSupport.gql_query(
    #         query: update_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:errors]).not_to be_blank
    #       expect(result[:errors]).to eq(["You have no permission to update a Author"])
    #     end

    #     it 'responses and error if current_user has no permissions' do
    #       user = create(:user)

    #       result = GqlSupport.gql_query(
    #         query: update_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:data][:updateAuthor]).to eq(nil)
    #       expect(result[:errors]).to eq(['You have no permission to update a Author'])
    #     end

    #     it 'responses and error if current_user has no permissions' do
    #       user = create(:user)

    #       result = GqlSupport.gql_query(
    #         query: update_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:data][:updateAuthor]).to eq(nil)
    #       expect(result[:errors]).to eq(['You have no permission to update a Author'])
    #     end

    #     it 'responses and error if current_user not signed in' do
    #       user = create(:user, :admin)

    #       result = GqlSupport.gql_query(
    #         query: update_mutation_query,
    #         context: { current_user: nil, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:data][:updateAuthor]).to eq(nil)
    #       expect(result[:errors]).to eq(['User not signed in'])
    #     end
    #   end

    #   describe 'when deleting a user' do
    #     it "deletes it if current_user has permissions" do
    #       user = create(:user, :admin)

    #       result = GqlSupport.gql_query(
    #         query: delete_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result.dig(:data, :deleteAuthor)).not_to be(nil)
    #       expect(result[:errors]).to be_blank
    #     end

    #     it 'responses and error if current_user has no permissions to view' do
    #       user = create(:user)

    #       result = GqlSupport.gql_query(
    #         query: delete_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:errors]).not_to be_blank
    #       expect(result[:errors]).to eq(["You have no permission to delete a Author"])
    #     end

    #     it 'responses and error if current_user has no permissions' do
    #       user = create(:user)

    #       result = GqlSupport.gql_query(
    #         query: delete_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:data][:deleteAuthor]).to eq(nil)
    #       expect(result[:errors]).to eq(['You have no permission to delete a Author'])
    #     end

    #     it 'responses and error if current_user has no permissions' do
    #       user = create(:user)

    #       result = GqlSupport.gql_query(
    #         query: delete_mutation_query,
    #         context: { current_user: user, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:data][:deleteAuthor]).to eq(nil)
    #       expect(result[:errors]).to eq(['You have no permission to delete a Author'])
    #     end

    #     it 'responses and error if current_user not signed in' do
    #       user = create(:user, :admin)

    #       result = GqlSupport.gql_query(
    #         query: delete_mutation_query,
    #         context: { current_user: nil, current_ability: Ability.new(user) }
    #       ).to_h.deep_symbolize_keys

    #       expect(result[:data][:deleteAuthor]).to eq(nil)
    #       expect(result[:errors]).to eq(['User not signed in'])
    #     end
    #   end

    #   def create_mutation_query
    #     user = create(:user)

    #     <<~GQL
    #       mutation{
    #         createAuthor (user:{
    #           firstName: "#{user.first_name}",
    #           lastName: "#{user.last_name}",
    #           yob: #{user.yob},
    #           isAlive: #{user.is_alive},
    #           bio: "#{user.bio}"
    #         }) {
    #           id
    #           first_name
    #         }
    #       }
    #     GQL
    #   end

    #   def update_mutation_query
    #     user = create(:user)

    #     <<~GQL
    #       mutation{
    #         updateAuthor (id: #{user.id}, user:{
    #           firstName: "New Author Name",
    #         }) {
    #           id
    #           firstName
    #         }
    #       }
    #     GQL
    #   end

    #   def delete_mutation_query
    #     user = create(:user)

    #     <<~GQL
    #       mutation{
    #         deleteAuthor (id: #{user.id})
    #       }
    #     GQL
    #   end
    # end

    def json_body
      json = JSON.parse(response.body)
      json.is_a?(Hash) ? json.with_indifferent_access : json # could be an array
    end
  end
end
