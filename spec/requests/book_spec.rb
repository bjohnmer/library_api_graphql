# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /graphql' do
  describe 'book' do
    describe 'resolvers' do
      before do
        user = create(:user)
        sign_in_user(user)
      end

      it 'responses with all books' do
        create_list(:book, 3)

        query = "{books{\n    id\n    title }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:books].count).to eq(3)
      end

      it 'responses with all filtered books' do
        create_list(:book, 3)

        query = "{books(filter: { yop: #{Book.first.yop}}){\n    id\n    title }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:books].count).to eq(1)
      end

      it 'responses with all paginated books' do
        create_list(:book, 6)

        query = "{books(first: 3, skip: 2){\n    id\n    title }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:books].count).to eq(3)
        expect(json_body[:data][:books].first['id']).to eq(Book.third.id.to_s)
      end

      it 'gets the given book by its id' do
        books = create_list(:book, 3)

        query = "{book(id: #{books[0].id}){\n    id\n    title }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data]).to include({book:{'id': books[0].id.to_s, 'title': books[0].title}})
      end

      it 'response an error if wrong id given' do
        create_list(:book, 3)

        query = "{book(id: 33){\n    id\n    title }}"
        post api_path(format: :json, 'query': query)

        expect(json_body[:data][:book]).to eq(nil)
        expect(json_body[:errors]).to eq(['Couldn\'t find Book with \'id\'=33'])
      end
    end

    describe 'mutations' do
      describe 'when creating a book' do
        it "creates it if current_user has permissions" do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: create_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result.dig(:data, :createBook)).not_to be(nil)
          expect(result.dig(:data, :createBook, :title)).
            to eq('New Book 1')
          expect(result[:errors]).to be_blank
        end

        it 'responses and error if current_user has no permissions to view' do
          user = create(:user)

          result = GqlSupport.gql_query(
            query: create_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:errors]).not_to be_blank
          expect(result[:errors][0][:message]).not_to be(nil)
        end

        it 'responses and error if current_user has no permissions' do
          allow(Mutations::Books::CreateBook).to receive(:visible?).and_return(true)
          user = create(:user)

          result = GqlSupport.gql_query(
            query: create_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:createBook]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to create a Book'])
        end

        it 'responses and error if current_user has no permissions' do
          allow(Mutations::Books::CreateBook).to receive(:visible?).and_return(true)
          user = create(:user)

          result = GqlSupport.gql_query(
            query: create_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:createBook]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to create a Book'])
        end

        it 'responses and error if current_user not signed in' do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: create_mutation_query,
            context: { current_user: nil, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:createBook]).to eq(nil)
          expect(result[:errors]).to eq(['User not signed in'])
        end
      end

      describe 'when updating a book' do
        it "update it if current_user has permissions" do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: update_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result.dig(:data, :updateBook)).not_to be(nil)
          expect(result.dig(:data, :updateBook, :title)).
            to eq('New Book Name')
          expect(result[:errors]).to be_blank
        end

        it 'responses and error if current_user has no permissions to view' do
          user = create(:user)

          result = GqlSupport.gql_query(
            query: update_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:errors]).not_to be_blank
          expect(result[:errors]).to eq(["You have no permission to update a Book"])
        end

        it 'responses and error if current_user has no permissions' do
          allow(Mutations::Books::CreateBook).to receive(:visible?).and_return(true)
          user = create(:user)

          result = GqlSupport.gql_query(
            query: update_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:updateBook]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to update a Book'])
        end

        it 'responses and error if current_user has no permissions' do
          allow(Mutations::Books::CreateBook).to receive(:visible?).and_return(true)
          user = create(:user)

          result = GqlSupport.gql_query(
            query: update_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:updateBook]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to update a Book'])
        end

        it 'responses and error if current_user not signed in' do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: update_mutation_query,
            context: { current_user: nil, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:updateBook]).to eq(nil)
          expect(result[:errors]).to eq(['User not signed in'])
        end
      end

      describe 'when deleting a book' do
        it "deletes it if current_user has permissions" do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: delete_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result.dig(:data, :deleteBook)).not_to be(nil)
          expect(result[:errors]).to be_blank
        end

        it 'responses and error if current_user has no permissions to view' do
          user = create(:user)

          result = GqlSupport.gql_query(
            query: delete_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:errors]).not_to be_blank
          expect(result[:errors]).to eq(["You have no permission to delete a Book"])
        end

        it 'responses and error if current_user has no permissions' do
          allow(Mutations::Books::CreateBook).to receive(:visible?).and_return(true)
          user = create(:user)

          result = GqlSupport.gql_query(
            query: delete_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:deleteBook]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to delete a Book'])
        end

        it 'responses and error if current_user has no permissions' do
          allow(Mutations::Books::CreateBook).to receive(:visible?).and_return(true)
          user = create(:user)

          result = GqlSupport.gql_query(
            query: delete_mutation_query,
            context: { current_user: user, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:deleteBook]).to eq(nil)
          expect(result[:errors]).to eq(['You have no permission to delete a Book'])
        end

        it 'responses and error if current_user not signed in' do
          user = create(:user, :admin)

          result = GqlSupport.gql_query(
            query: delete_mutation_query,
            context: { current_user: nil, current_ability: Ability.new(user) }
          ).to_h.deep_symbolize_keys

          expect(result[:data][:deleteBook]).to eq(nil)
          expect(result[:errors]).to eq(['User not signed in'])
        end
      end

      def create_mutation_query
        author = create(:author)
        category = create(:category)

        <<~GQL
          mutation{
            createBook (book:{
              title: "New Book 1",
              yop: 2013,
              categoryId: #{category.id},
              authorId:  #{author.id}
            }) {
              id
              title
            }
          }
        GQL
      end

      def update_mutation_query
        book = create(:book)

        <<~GQL
          mutation{
            updateBook (id: #{book.id}, book:{
              title: "New Book Name",
            }) {
              id
              title
            }
          }
        GQL
      end

      def delete_mutation_query
        book = create(:book)

        <<~GQL
          mutation{
            deleteBook (id: #{book.id})
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
