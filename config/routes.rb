Rails.application.routes.draw do
  get 'welcome/index'

  resources :repositories do
    member do
      post :report
    end
  end

  root 'welcome#index'

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'
end
