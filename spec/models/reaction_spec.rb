require 'rails_helper'

RSpec.describe Reaction, type: :model do
  describe "validations" do
    it { should belong_to(:user) }
    it { should belong_to(:micropost) }
    it { should validate_presence_of(:reaction_type)}
  end
end

