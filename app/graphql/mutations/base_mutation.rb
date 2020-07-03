# frozen_string_literal: true

module Mutations
  # Base GraphQL mutation class
  class BaseMutation < GraphQL::Schema::Mutation
    protected

    def authenticated_user?(action, class_name, signing_out = false)
      check_ability(action, class_name, signing_out)

      return true if context[:current_user].present?

      raise GraphQL::ExecutionError, 'User not signed in'
    end

    private

    def check_ability(action, class_name, signing_out)
      ability = context[:current_ability]

      msg = 'You must be signed in to view this information'
      raise GraphQL::ExecutionError, msg if !ability.present? && !signing_out

      msg = 'User not signed in'
      raise GraphQL::ExecutionError, msg unless ability.present?

      msg = "You have no permission to #{action} a #{class_name}"
      will_raise = !ability.can?(action, class_name) && !signing_out

      raise GraphQL::ExecutionError, msg if will_raise
    end
  end
end
