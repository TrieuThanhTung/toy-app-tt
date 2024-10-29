require 'rails_helper'

RSpec.describe Provider, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  let(:user) {
    create(:user)
  }

  it "Provider is valid with valid attributes" do
    should belong_to(:user)
    should validate_presence_of(:name)
    should validate_presence_of(:uid)
  end

  it "Provider is not valid without a user" do
    should belong_to(:user)
  end

  it "Provider is not valid without a name" do
    should validate_presence_of(:name)
  end

  it "Provider is not valid without uid" do
    should validate_presence_of(:uid)
  end
end
