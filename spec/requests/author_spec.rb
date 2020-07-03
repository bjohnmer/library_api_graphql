# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /graphql' do
  describe 'author' do
    describe 'resolvers' do
      before do
        user = create(:user)
        sign_in_user(user)
      end

      it 'responses with all authors' do
        create_list(:author, 3)

        query = "{authors{\n    id\n    fullName }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:authors].count).to eq(3)
      end

      it 'responses with all filtered authors' do
        create_list(:author, 3)

        query = "{authors(filter: { yob: #{Author.first.yob}}){\n    id\n    firstName }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:authors].count).to eq(1)
      end

      it 'responses with all paginated authors' do
        create_list(:author, 6)

        query = "{authors(first: 3, skip: 2){\n    id\n    firstName }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:authors].count).to eq(3)
        expect(json_body[:data][:authors].first['id']).to eq(Author.third.id.to_s)
      end

      it 'responses with the given author by its id' do
        authors = create_list(:author, 3)

        query = "{author(id: #{authors[0].id}){\n    id\n    fullName }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data]).to include({author:{'id': authors[0].id.to_s, 'fullName': authors[0].full_name}})
      end

      it 'response an error if wrong id given' do
        create_list(:author, 3)

        query = "{author(id: 33){\n    id\n    fullName }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:author]).to eq(nil)
        expect(json_body[:errors]).to eq(['Couldn\'t find Author with \'id\'=33'])
      end
    end

    describe 'mutations' do
      describe 'when creating a author' do
        it "creates it if current_user has permissions" do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: create_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result.dig(:data, :createAuthor)).not_to be(nil)
          expect(result.dig(:data, :createAuthor, :fullName)).
            not_to be(nil)
          expect(result[:errors]).to be_blank
        end

        it 'responses and error if current_user has no permissions to view' do
          user = create(:user)

          result = GqlSupport.gql_query(
            query: create_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result.dig(:data, :createAuthor)).to be(nil)
          expect(result[:errors]).not_to be_blank
          expect(result[:errors]).to eq(["You have no permission to create a Author"])
        end

        it 'responses and error if current_user has no permissions' do
          allow(Mutations::Authors::CreateAuthor).to receive(:visible?).and_return(true)
          user = create(:user)

          result = GqlSupport.gql_query(
            query: create_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:createAuthor]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to create a Author'])
        end

        it 'responses and error if current_user has no permissions' do
          allow(Mutations::Authors::CreateAuthor).to receive(:visible?).and_return(true)
          user = create(:user)

          result = GqlSupport.gql_query(
            query: create_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:createAuthor]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to create a Author'])
        end

        it 'responses and error if current_user not signed in' do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: create_mutation_query,
            context: { current_user: nil, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:createAuthor]).to eq(nil)
          expect(result[:errors]).to eq(['User not signed in'])
        end
      end

      describe 'when updating a author' do
        it "update it if current_user has permissions" do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: update_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result.dig(:data, :updateAuthor)).not_to be(nil)
          expect(result.dig(:data, :updateAuthor, :firstName)).
            to eq('New Author Name')
          expect(result[:errors]).to be_blank
        end

        it 'responses and error if current_user has no permissions to view' do
          user = create(:user)

          result = GqlSupport.gql_query(
            query: update_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:errors]).not_to be_blank
          expect(result[:errors]).to eq(["You have no permission to update a Author"])
        end

        it 'responses and error if current_user has no permissions' do
          user = create(:user)

          result = GqlSupport.gql_query(
            query: update_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:updateAuthor]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to update a Author'])
        end

        it 'responses and error if current_user has no permissions' do
          user = create(:user)

          result = GqlSupport.gql_query(
            query: update_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:updateAuthor]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to update a Author'])
        end

        it 'responses and error if current_user not signed in' do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: update_mutation_query,
            context: { current_user: nil, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:updateAuthor]).to eq(nil)
          expect(result[:errors]).to eq(['User not signed in'])
        end
      end

      describe 'when deleting a author' do
        it "deletes it if current_user has permissions" do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: delete_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result.dig(:data, :deleteAuthor)).not_to be(nil)
          expect(result[:errors]).to be_blank
        end

        it 'responses and error if current_user has no permissions to view' do
          user = create(:user)

          result = GqlSupport.gql_query(
            query: delete_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:errors]).not_to be_blank
          expect(result[:errors]).to eq(["You have no permission to delete a Author"])
        end

        it 'responses and error if current_user has no permissions' do
          user = create(:user)

          result = GqlSupport.gql_query(
            query: delete_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:deleteAuthor]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to delete a Author'])
        end

        it 'responses and error if current_user has no permissions' do
          user = create(:user)

          result = GqlSupport.gql_query(
            query: delete_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:deleteAuthor]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to delete a Author'])
        end

        it 'responses and error if current_user not signed in' do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: delete_mutation_query,
            context: { current_user: nil, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:deleteAuthor]).to eq(nil)
          expect(result[:errors]).to eq(['User not signed in'])
        end
      end

      def create_mutation_query
        author = create(:author)

        <<~GQL
          mutation{
            createAuthor (author:{
              firstName: "#{author.first_name}",
              lastName: "#{author.last_name}",
              yob: #{author.yob},
              isAlive: #{author.is_alive},
              bio: "#{author.bio}"
            }) {
              id
              fullName
            }
          }
        GQL
      end

      def update_mutation_query
        author = create(:author)

        <<~GQL
          mutation{
            updateAuthor (id: #{author.id}, author:{
              firstName: "New Author Name",
            }) {
              id
              firstName
            }
          }
        GQL
      end

      def delete_mutation_query
        author = create(:author)

        <<~GQL
          mutation{
            deleteAuthor (id: #{author.id})
          }
        GQL
      end
    end

    def json_body
      json = JSON.parse(response.body)
      json.is_a?(Hash) ? json.with_indifferent_access : json # could be an array
    end
  end
end
