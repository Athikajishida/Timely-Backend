# spec/integration/events_spec.rb
require 'swagger_helper'

RSpec.describe 'events', type: :request do
  path '/events' do
    get('list events') do
      tags 'Events'
      security [bearerAuth: []]  # Require JWT token for this request
      produces 'application/json'
      
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create event') do
      tags 'Events'
      security [bearerAuth: []]  # Require JWT token for this request
      consumes 'application/json'
      produces 'application/json'

      response(201, 'event created') do
        let(:event) { { title: 'Sample Event', description: 'Sample description', date: '2024-10-24' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/events/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show event') do
      tags 'Events'
      security [bearerAuth: []]  # Require JWT token for this request
      produces 'application/json'
      
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
