Rails.application.routes.draw do

  resources :artifacts
  #resources :projects
  
  resources :tenants do
    resources :projects
  end
  
  
  resources :members
  get 'home/index'

   root :to => "home#index"

    
  # *MUST* come *BEFORE* devise's definitions (below)
  as :user do   
    #match '/user/confirmation' => 'milia/confirmations#update', :via => :put, :as => :update_user_confirmation
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  devise_for :users, :controllers => { 
    #:registrations => "milia/registrations",
    :registrations => "registrations",
    #:confirmations => "milia/confirmations",
    :confirmations => "confirmations",
    :sessions => "milia/sessions", 
    :passwords => "milia/passwords", 
  }
  
  match '/plan/edit' => 'tenants#edit', via: :get, as: :edit_plan
  match '/plan/update' => 'tenants#update', via: [:put, :patch], as: :update_plan


end
