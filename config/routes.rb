Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static#index'
  resources :messages
  match '/profile/:user_id', to: 'users#show',  via: 'get', as: :profile


  # Routes for Testing
  get '/test_greet_intent', to: 'messages#test_greet_intent'
  get '/test_twilio_send', to: 'messages#test_twilio_send'
  get '/test_register_intent', to: 'messages#test_register_intent'
  get '/test_add_meal_intent', to: 'messages#test_add_meal_intent'
  get '/test_profile_intent', to: 'messages#test_profile_intent'
  get '/test_caloric_information_intent', to: 'messages#test_caloric_information_intent'
  get '/test_add_calories_intent', to: 'messages#test_add_calories_intent'
  get '/test_unknown_user', to: 'messages#test_unknown_user'
  get '/charttesting', to: 'users#chart_testing'

end
