# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registration API', type: :request do
  describe 'POST /signup' do
    let(:valid_attributes) do
      { name: 'John Doe', email: 'john@example.com', password: 'password', phonenumber: '1234567890' }
    end

    it 'registers a new user and returns a token' do
      post '/signup', params: valid_attributes
      expect(response).to have_http_status(:created)
      puts response.body

      expect(JSON.parse(response.body)['token']).not_to be_nil
    end

    it 'returns an error if registration fails' do
      post '/signup', params: { name: '', email: 'invalid', password: '', phonenumber: '' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
