Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static#index'
  resources :messages

  # Routes for Testing
  get '/profile/:user_id', to: 'users#show'
  get '/test_twilio_send', to: 'messages#test_twilio_send'
  get '/test_register_intent', to: 'messages#test_register_intent'
  get '/test_add_item_intent', to: 'messages#test_add_item_intent'
  get '/test_profile_intent', to: 'messages#test_profile_intent'
  get '/test_caloric_information_intent', to: 'messages#test_caloric_information_intent'

end
