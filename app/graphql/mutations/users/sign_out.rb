# frozen_string_literal: true

module Mutations
  module Users
    # Sing out class
    class SignOut < Mutations::BaseMutation
      description 'SignOut'

      type Boolean

      def resolve
        authenticated_user?(nil, nil, true)
        true
      end
    end
  end
end
