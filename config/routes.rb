Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'top#index'
  resources :attendances
  resources :users, except: :index do
    collection do
      get :login
      post :login_post
      delete :logout #TODO delete
    end
  end
end
