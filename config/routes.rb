# frozen_string_literal: true

Rails.application.routes.draw do
  post '/login', to: 'sessions#create'
  post '/signup', to: 'registrations#create'
  post '/confirm_email', to: 'registrations#confirm_email' # For OTP confirmation
  post '/confirm_otp', to: 'otp_confirmations#confirm'
  get '/schedule/:token', to: 'events#show_by_token'

  resources :events, only: %i[index create show update destroy]
  resources :bookings, only: %i[index create]
end
