# frozen_string_literal: true

module Resolvers
  class Base < GraphQL::Schema::Resolver
    protected

    def authenticated_user?(action, class_name)
      unless context[:current_ability]
        msg = 'You must be signed in to view this information'
        raise GraphQL::ExecutionError, msg
      end

      unless context[:current_ability].can?(action, class_name)
        msg = "You have no permission to #{action} a #{class_name}"
        raise GraphQL::ExecutionError, msg
      end

      return true if context[:current_user].present?

      raise GraphQL::ExecutionError, 'User not signed in'
    end
  end
end
