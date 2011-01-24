JTable::Application.routes.draw do
  resources :widgets do
    get :server_side, :on => :collection
  end
  root :to => "widgets#index"
end
