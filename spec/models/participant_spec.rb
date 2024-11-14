require 'rails_helper'

RSpec.describe Participant, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  describe "Validations" do
    it { should belong_to(:user) }
    it { should belong_to(:room) }
  end
end
