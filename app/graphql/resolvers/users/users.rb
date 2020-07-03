require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers::Users
  class Users < Resolvers::Base
    # include SearchObject for GraphQL
    include SearchObject.module(:graphql)

    # Starting point for searching
    scope do
      authenticated_user?(:read, User)
      ::User.all
    end

    description 'Show all users'

    # Define arguments for the filter
    class UsersFilter < ::Types::BaseInputObject
      argument :OR, [self], required: false
      argument :email, String, required: false
      argument :name_contains, String, required: false
    end

    type [Types::UserType], null: true

    # when object "filter" is passed "apply_filter" will be called
    option :filter, type: UsersFilter, with: :apply_filter

    # apply_filter calls recursively through all "OR" and "AND" arguments
    def apply_filter(scope, value)
      branches = normalize_filters(value).reduce { |a, b| a.or(b) }
      scope.merge branches
    end

    def normalize_filters(value, branches = [])
      scope = ::User.all
      # for Postgresql
      # scope = scope.where('TRIM(CONCAT(first_name, ' ', last_name)) LIKE ?', "%#{value[:name_contains]}%") if value[:name_contains]

      # for SQLite
      scope = scope.where(email: value[:email]) if value[:email]
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
