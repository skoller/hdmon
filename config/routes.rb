Hdmon::Application.routes.draw do
  
  root :to => 'application#home_page'
  
  resources :physicians do
    resources :patients do
      resources :log_entries
    end
  end
  
  post 'physician_signup_part2/:id(.:format)' => 'physicians#signup_part2', :as => "physician_signup_part2"
  post "home_page" => "application#home_page", :as => "home_page"
  post "deactivate_pt_msg/:physician_id/:patient_id" => "physicians#deactivate_pt_message", :as => "deactivate_pt_message"
  post "deactivate_ph_msg/:physician_id" => "physicians#deactivate_ph_message", :as => "deactivate_ph_message"
  post "ph_deactivate" => "physicians#destroy_archive", :as => "destroy_archive"
  post "pt_archive/:physician_id/:id" => "patients#archive", :as => "archive_pt"
  post "physician/:physician_id/patient_archive" => "physicians#pt_archive_index", :as => "pt_archive_index"
  post "code" => "sessions#new_patient_code_verification", :as => "patient_code"
  post "new_patient" => "sessions#new_patient_start_code_entry", :as => "new_patient_start_code_entry"
  post "new_patient_password_setup/:pt_id" => "sessions#new_patient_password_setup", :as => "new_patient_password_setup"
  post "p_set/:pt_id" => "sessions#password_set", :as => "password_set"
  
  
  
  # flash.now.alert=
  post 'phone/sms_handler' => "phone#sms_handler", :as => "sms_handler"
  post 'after_start_code_web_handler' => "patients#after_start_code_web_handler", :as => "after_start_code_web_handler"
  
  post "physician_log_out" => "sessions#destroy_ph", :as => "log_out"
  post "physician_log_in" => "sessions#new_physician_session", :as => "log_in"
  post "physician_find" => "sessions#create_ph_session", :as => "posted"
  post "physician_sign_up" => "physicians#new", :as => "sign_up"
  post "physician_additional_info" => "physicians#physician_additional_info", :as => "physician_additional_info"
  post "welcome_ph_instructions/:physician_id" => "physicians#welcome_ph_instructions", :as => "welcome_ph_instructions" 
  post "unarch_pt/:id/:patient_id" => "physicians#unarchive_patient", :as => "unarchive_patient"
  post "physician_account/:physician_id" => "physicians#physician_account", :as => "physician_account"
  post "edit_physician_account/:physician_id" => "physicians#edit_physician_account", :as => "edit_physician_account"
  post "physician_pswd_edit/:physician_id" => "physicians#ph_password_edit", :as => 'ph_password_edit'
  post "physician_pswd_update/:physician_id" => "physicians#ph_password_update", :as => 'ph_password_update'
  
  
  post "patient_log_out" => "sessions#destroy_pt", :as => "patient_log_out"
  post "patient_log_in" => "sessions#new_patient_session", :as => "patient_log_in"
  post "patient_find" => "sessions#create_pt_session", :as => "patient_posted"
  post "patient_edit/:patient_id" => "patients#patient_edit_limited", :as => "pt_edit"
  post "patient_show/:patient_id" => "patients#patient_show_limited", :as => "pt_show"
  post "patient_update/:patient_id" => "patients#patient_update_limited", :as => "pt_update"
  post "patient_welcome/:patient_id" => "patients#patient_welcome", :as => "patient_welcome"
  
  
  post "admin_override_pt_password_edit/:patient_id" => "patients#admin_pt_password_edit", :as => "admin_pt_pass_edit"
  post "admin_override_pt_password_update/:patient_id" => "patients#admin_pt_password_update", :as => "admin_pt_pass_update"
  post "admin" => "admin#index", :as => "admin"
  post "archived_physicians" => "admin#archived_physicians", :as => "archived_physicians"
  post "archived_patients" => "admin#archived_patients", :as => "archived_patients"
  post "active_patients" => "admin#active_patients", :as => "active_patients"
  post "deact_and_arch_pt/:patient_id" => "admin#deactivate_and_archive_patient", :as => "deactivate_and_archive_patient"
  post "react_and_unarch_pt/:patient_id" => "admin#reactivate_and_unarchive_patient", :as => "reactivate_and_unarchive_patient"
  post "archive_a_physician/:physician_id" => "admin#archive_a_physician", :as => "archive_a_physician"
  post "unarchive_a_physician/:physician_id" => "admin#unarchive_a_physician", :as => "unarchive_a_physician"
  

    
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible post GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
