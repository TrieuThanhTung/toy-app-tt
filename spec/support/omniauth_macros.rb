module OmniAuthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: '123456789',
      info: {
        email: 'test@example.com',
        first_name: 'Test',
        last_name: 'User',
        name: "Test User",
        nickname: "Nick name user"
      }
    )
  end

  def mock_auth_invalid(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
  end
end
