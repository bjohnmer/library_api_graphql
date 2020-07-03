# frozen_string_literal: true

require "rails_helper"

RSpec.describe Resolvers::Base do
  describe '#authenticated_user?' do
    let(:user) { create(:user, :admin) }
    before do
      allow_any_instance_of(Ability).to receive(:can?).and_return(true)
    end

    it "returns true if user is signed in" do
      resolver = Resolvers::Base.new(
        object: nil,
        field:nil,
        context: { current_user: user, current_ability: Ability.new(user) }
      )
      expect(resolver.send(:authenticated_user?, :read, User)).to eq(true)
    end

    it "raise an error if not signed in" do
      resolver = Resolvers::Base.new(
        object: nil,
        field:nil,
        context: { current_user: nil, current_ability: nil }
      )
      expect { resolver.send(:authenticated_user?, :read, User) }.
        to raise_error(GraphQL::ExecutionError)
    end

    it "raise an error if not user provided" do
      resolver = Resolvers::Base.new(
        object: nil,
        field:nil,
        context: { current_user: nil, current_ability: Ability.new(user) }
      )
      expect { resolver.send(:authenticated_user?, :read, User) }.
        to raise_error(GraphQL::ExecutionError)
    end

    it "raise an error if user has no ability" do
      allow_any_instance_of(Ability).to receive(:can?).and_return(false)

      resolver = Resolvers::Base.new(
        object: nil,
        field:nil,
        context: { current_user: nil, current_ability: Ability.new(user) }
      )
      expect { resolver.send(:authenticated_user?, :read, User) }.
        to raise_error(GraphQL::ExecutionError)
    end
  end
end
