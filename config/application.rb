# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require_relative '../lib/json_web_token'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TimelyBackend
  class Application < Rails::Application
    config.load_defaults 7.1
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:5173'
        resource '*',
                 headers: :any,
                 methods: %i[get post put patch delete options head],
                 credentials: true
      end
    end

    config.autoload_paths << Rails.root.join('lib')

    config.api_only = true
  end
end
