FixMyTumblrTags::Application.routes.draw do
  root :to => "home#index"
  resources :users, :only => [ :show, :edit, :update, :edit_tags ]
  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/auth/failure' => 'sessions#failure'
  match '/users/edit_tags' => 'users#edit_tags'
end
