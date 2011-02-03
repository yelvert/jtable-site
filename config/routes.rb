JTable::Application.routes.draw do
  resources :icd_codes
  
  resources :widgets
  
  root :to => "icd_codes#index"
end
