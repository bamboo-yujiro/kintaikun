Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'attendances#index'
  resources :attendances
  resources :users, :except => :index do
    collection do
      get :login
      post :login_post
    end
  end
end
