require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  let(:user) {
    create(:user)
  }

  let(:micropost) {
    create(:micropost)
  }

  let(:valid_comment) {
    {
      'content' => "content",
    }
  }

  let(:invalid_comment) {
    {
      'content' => ""
    }
  }

  before do
    Rails.application.env_config["omniauth.auth"] = mock_auth_hash(:google_oauth2)
    post user_google_oauth2_omniauth_callback_path
  end

  describe "POST /microposts/:micropost_id/comments" do

    context "create a new comment" do
      it "works!" do
        post micropost_comments_path(micropost), params: { micropost: valid_comment }
        expect(Micropost.count).to eq(2)
        expect(response).to have_http_status(:created)
      end

      it " fail!" do
        post micropost_comments_path(micropost), params: { micropost: invalid_comment }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /microposts/:micropost_id/comments/:comment_id/reply" do
    before do
      post micropost_comments_path(micropost), params: { micropost: valid_comment }
    end

    context "create a new comment(reply)" do
      it "works!" do
        post micropost_comment_reply_path(micropost_id: micropost.id, comment_id: Micropost.first.id), params: { micropost: valid_comment }
        expect(Micropost.count).to eq(3)
        expect(response).to have_http_status(:created)
      end

      it " fail!" do
        post micropost_comment_reply_path(micropost_id: micropost.id, comment_id: Micropost.first.id), params: { micropost: invalid_comment }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
