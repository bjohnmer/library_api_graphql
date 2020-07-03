require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers::Books
  class Books < Resolvers::Base
    # include SearchObject for GraphQL
    include SearchObject.module(:graphql)

    description 'Show all books'

    # Starting point for searching
    scope do
      authenticated_user?(:read, Book)
      ::Book.all
    end

    # Define arguments for the filter
    class BookFilter < ::Types::BaseInputObject
      argument :OR, [self], required: false
      argument :title_contains, String, required: false
      argument :yop, Int, required: false
      argument :in_category, String, required: false
      argument :category_id, Int, required: false
      argument :author_name_contains, String, required: false
    end

    type [Types::BookType], null: true

    # when object "filter" is passed "apply_filter" will be called
    option :filter, type: BookFilter, with: :apply_filter

    # apply_filter calls recursively through all "OR" and "AND" arguments
    def apply_filter(scope, value)
      branches = normalize_filters(value).reduce { |a, b| a.or(b) }
      scope.merge branches
    end

    def normalize_filters(value, branches = [])
      scope = ::Book.all
      scope = scope.joins(:category).where('categories.name LIKE ?', "%#{value[:in_category]}%") if value[:in_category]

      # for Postgresql
      # scope = scope.joins(:authors).where('TRIM(CONCAT(authors.first_name, ' ', authors.last_name))  LIKE ?', "%#{value[:author_name_contains]}%") if value[:author_name_contains]

      # for SQLite
      scope = scope.joins(:authors).where('authors.first_name || authors.last_name LIKE ?', "%#{value[:author_name_contains]}%") if value[:author_name_contains]

      scope = scope.where('category_id = ?', value[:category_id]) if value[:category_id]
      scope = scope.where('yop = ?', value[:yop]) if value[:yop]


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
