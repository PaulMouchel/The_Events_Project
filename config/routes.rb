Rails.application.routes.draw do
  devise_for :users
	root 'events#index'
  resources :events do
  	resources :attendances
  	resources :event_pics, only: [:create]
  end
  resources :users, only: [:show, :edit, :update] do
  	resources :user_pics, only: [:create]
  end
  namespace :admin do
    resources :users
    resources :events_submissions, only: [:show, :index, :update, :destroy]
    resources :events do
      resources :attendances
    end
    
  end

end
