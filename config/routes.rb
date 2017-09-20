Rails.application.routes.draw do
  resources :group_events do
    member do
      patch 'publish'
    end
  end
end
