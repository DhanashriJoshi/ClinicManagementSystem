Rails.application.routes.draw do
  resources :treatments
  resources :appointments
  resources :doctors
  resources :diseases do
    collection do
      get :upload_file
      post :upload
    end
  end
  resources :patients
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
