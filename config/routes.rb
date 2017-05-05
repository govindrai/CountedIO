Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static#index'
  post '/', to: 'users#index'
  post '/messages/invite_user/', to: 'messages#invite_user', as: :invite_user



  resources :messages
  match '/profile/:user_id', to: 'users#show',  via: 'get', as: :profile

  get '/profile/:user_id/get_data', to: 'users#get_data', as: :get_data

  get '/profile/:user_id/get_day_meals', to: 'users#get_day_meals', as: :get_day_meals





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
