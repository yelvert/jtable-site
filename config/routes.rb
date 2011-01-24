JTable::Application.routes.draw do
  resources :widgets do
    get :client_side, :on => :collection
  end
  root :to => "widgets#index"
end
