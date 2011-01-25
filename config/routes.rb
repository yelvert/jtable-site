JTable::Application.routes.draw do
  resources :icd_codes

  resources :widgets do
    get :client_side, :on => :collection
  end
  root :to => "icd_codes#index"
end
