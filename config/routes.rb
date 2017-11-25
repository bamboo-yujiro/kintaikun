Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'top#index'
  resources :attendances, except: [:show, :destroy, :new, :create] do #TODO new, create について
    collection do
      get :sheet
    end
  end
  resources :users, except: [:index, :destroy, :show, :update, :edit] do
    collection do
      get :login
      post :login_post
      delete :logout
    end
  end
end
