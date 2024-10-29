require 'rails_helper'

RSpec.describe "Users::Auths", type: :request do
  describe "login google_oauth2" do
    context "success" do
      before do
        Rails.application.env_config["omniauth.auth"] = mock_auth_hash(:google_oauth2)
      end

      it "POST" do
        post user_google_oauth2_omniauth_callback_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(user_url(User.last))
        expect(session[:user_id]).to eq User.last.id
      end
    end

    context "fail" do
      before do
        Rails.application.env_config["omniauth.auth"] = mock_auth_invalid(:google_oauth2)
      end

      it "POST" do
        post user_google_oauth2_omniauth_callback_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "login github" do
    context "success" do
      before do
        Rails.application.env_config["omniauth.auth"] = mock_auth_hash(:github)
      end

      it "POST" do
        post user_github_omniauth_callback_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(user_url(User.last))
        expect(session[:user_id]).to eq User.last.id
      end
    end

    context "fail" do
      before do
        Rails.application.env_config["omniauth.auth"] = mock_auth_invalid(:github)
      end

      it "POST" do
        post user_google_oauth2_omniauth_callback_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "login facebook" do
    context "success" do
      before do
        Rails.application.env_config["omniauth.auth"] = mock_auth_hash(:facebook)
      end

      it "POST" do
        post user_facebook_omniauth_callback_path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(user_url(User.last))
        expect(session[:user_id]).to eq User.last.id
      end
    end

    context "fail" do
      before do
        Rails.application.env_config["omniauth.auth"] = mock_auth_invalid(:facebook)
      end

      it "POST" do
        post user_google_oauth2_omniauth_callback_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
