require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers::Authors
  class Authors < Resolvers::Base
    # include SearchObject for GraphQL
    include SearchObject.module(:graphql)

    # Starting point for searching
    scope do
      authenticated_user?(:read, Author)
      ::Author.all
    end

    description 'Show all authors'

    # Define arguments for the filter
    class AuthorFilter < ::Types::BaseInputObject
      argument :OR, [self], required: false
      argument :name_contains, String, required: false
      argument :bio_contains, String, required: false
      argument :book_contains, String, required: false
      argument :yob, Int, required: false
      argument :is_alive, Boolean, required: false
    end

    type [Types::AuthorType], null: true

    # when object "filter" is passed "apply_filter" will be called
    option :filter, type: AuthorFilter, with: :apply_filter

    # apply_filter calls recursively through all "OR" and "AND" arguments
    def apply_filter(scope, value)
      branches = normalize_filters(value).reduce { |a, b| a.or(b) }
      scope.merge branches
    end

    def normalize_filters(value, branches = [])
      scope = ::Author.all
      scope = scope.joins(:books).where('books.title LIKE ?', "%#{value[:book_contains]}%") if value[:book_contains]
      scope = scope.where('yob = ?', value[:yob]) if value[:yob]
      scope = scope.where('is_alive = ?', value[:is_alive]) if value[:is_alive]
      scope = scope.where('bio LIKE ?', "%#{value[:bio_contains]}%") if value[:bio_contains]

      # for Postgresql
      # scope = scope.where('TRIM(CONCAT(first_name, ' ', last_name)) LIKE ?', "%#{value[:name_contains]}%") if value[:name_contains]

      # for SQLite
      scope = scope.where('(first_name || last_name) LIKE ?', "%#{value[:name_contains]}%") if value[:name_contains]

      branches << scope
      value[:OR].reduce(branches) { |s, v| normalize_filters(v, s) } if value[:OR].present?

      branches
    end

    # Pagination
    option :first, type: Int, with: :apply_first
    option :skip, type: Int, with: :apply_skip

    def apply_first(scope, value)
      scope.limit(value)
    end

    def apply_skip(scope, value)
      scope.offset(value)
    end
  end
end
