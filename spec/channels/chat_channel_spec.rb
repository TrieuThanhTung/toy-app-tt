require 'rails_helper'

RSpec.describe ChatChannel, type: :channel do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    stub_connection current_user: user1.id
  end

  context "when subscribing to a chat room" do
    it "successfully" do
      subscribe(user_id: user2.id)

      expect(subscription).to be_confirmed

      chat_channel = [ user1.id.to_s, user2.id.to_s ].sort.join("_")
      expect(subscription).to have_stream_from("chat_channel_private_#{chat_channel}")
    end

    it "fail" do
      subscribe()
      expect(subscription).to be_rejected
    end
  end

  context "when send message" do
    let(:valid_message) { {
      "message" => "new message"
    } }

    it "successfully" do
      subscribe(user_id: user2.id)

      expect {
        perform :create, valid_message
      }.to change(Message, :count).by(1)

      expect(Message.last.content).to eq("new message")
    end
  end

  context "when update message" do
    let(:valid_message) { {
      "message" => "new message"
    } }

    let(:update_message) { {
      "id" => Message.last.id,
      "message" => "message update"
    } }

    before do
      subscribe(user_id: user2.id)
      perform :create, valid_message
    end

    it "success" do
      expect {
        perform :update, {
          "id" => Message.last.id,
          "message" => "message update"
        }
      }.to change(Message, :count).by(0)

      expect(Message.last.content).to eq("message update")
    end

    it "fail" do
      expect {
        perform :update, {
          "id" => Message.last.id,
          "message" => ""
        }
      }.to change(Message, :count).by(0)

      expect(Message.last.content).to eq("new message")
    end
  end

  context "when delete message" do
    let(:valid_message) { {
      "message" => "new message"
    } }

    before do
      subscribe(user_id: user2.id)
      perform :create, valid_message
    end

    it "successfully" do
      expect {
        perform :delete, {
          "id" => Message.last.id
        }
      }.to change(Message, :count).by(-1)

      expect(Message.count).to eq(0)
    end
  end
end
