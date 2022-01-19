Rails.application.routes.draw do
  root to: "locations#home"
  devise_for :users
  resources :locations do
    get :copy
    get :individual_location, defaults: { format: :json }
    collection do
      get :all_locations, defaults: { format: :json }
    end
  end
end
