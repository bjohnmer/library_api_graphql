# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::BaseMutation do
  describe "#authorize_user" do
    let(:user) { create(:user, :admin) }
    before do
      allow_any_instance_of(Ability).to receive(:can?).and_return(true)
    end

    it "returns true if user is signed in" do
      mutation = Mutations::BaseMutation.new(
        object: nil,
        field:nil,
        context: { current_user: user, current_ability: Ability.new(user) }
      )
      expect(mutation.send(:authenticated_user?, nil, nil, true)).to eq(true)
    end

    it "raise an error if not signed in" do
      mutation = Mutations::BaseMutation.new(
        object: nil,
        field:nil,
        context: { current_user: nil, current_ability: nil }
      )
      expect { mutation.send(:authenticated_user?, nil, nil, false) }.
        to raise_error(GraphQL::ExecutionError)
    end

    it "raise an error if not user provided" do
      mutation = Mutations::BaseMutation.new(
        object: nil,
        field:nil,
        context: { current_user: nil, current_ability: Ability.new(user) }
      )
      expect { mutation.send(:authenticated_user?, nil, nil, false) }.
        to raise_error(GraphQL::ExecutionError)
    end
  end
end
