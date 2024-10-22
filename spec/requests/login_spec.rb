# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login API', type: :request do
  let!(:user) { User.create(email: 'user@example.com', password: 'password') }

  describe 'POST /login' do
    it 'logs in the user and returns a token' do
      post '/login', params: { email: user.email, password: 'password' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['token']).not_to be_nil
    end

    it 'returns an error with wrong credentials' do
      post '/login', params: { email: user.email, password: 'wrong_password' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
