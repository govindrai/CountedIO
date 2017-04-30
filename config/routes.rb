Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static#index'
  resources :messages

  # Routes for Testing
  get '/test_twilio_send', to: 'messages#test_twilio_send'
  get '/test_wit_send', to: 'messages#test_wit_send'

end
