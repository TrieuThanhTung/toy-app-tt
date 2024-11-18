require 'rails_helper'

RSpec.describe Message, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "Validations" do
    it { should belong_to(:sender) }
    it { should belong_to(:room) }
    it { should validate_presence_of(:content) }
  end
end
