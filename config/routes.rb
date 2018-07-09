Rails.application.routes.draw do
  get 'welcome/index'

  resources :repositories do
    member do
      post :report
    end
  end

  root 'welcome#index'


  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
