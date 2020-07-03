# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  it 'can manage all if user is admin' do
    user = build(:user, :admin)

    [User, Book, Author, Category].each do |class_name|
      expect(Ability.new(user).can? :manage, class_name).to eq(true)
    end
  end

  it 'cannot manage all if user is not admin' do
    user = build(:user)

    [User, Book, Author, Category].each do |class_name|
      expect(Ability.new(user).can? :manage, class_name).to eq(false)
    end
  end

  it 'can read all if user is not admin' do
    user = build(:user)

    [User, Book, Author, Category].each do |class_name|
      expect(Ability.new(user).can? :read, class_name).to eq(true)
    end
  end
end

