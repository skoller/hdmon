Hdmon::Application.routes.draw do

  root :to => 'application#home_page'



  #get 'physician_signup_part2/:id(.:format)' => 'physicians#signup_part2', :as => "physician_signup_part2G"
  put 'physician_signup_part2/:id(.:format)' => 'physicians#signup_part2', :as => "physician_signup_part2P"
  get "home_page" => "application#home_page", :as => "home_page"
  get "deactivate_pt_msg/:physician_id/:patient_id" => "physicians#deactivate_pt_message", :as => "deactivate_pt_message"
  get "deactivate_ph_msg/:physician_id" => "physicians#deactivate_ph_message", :as => "deactivate_ph_message"
  get "ph_deactivate" => "physicians#destroy_archive", :as => "destroy_archive"
  get "pt_archive/:physician_id/:id" => "patients#archive", :as => "archive_pt"
  get "physician/:physician_id/patient_archive" => "physicians#pt_archive_index", :as => "pt_archive_index"
  post "code" => "sessions#signup_code_verification", :as => "patient_code"
  get "signup" => "sessions#signup_start_code_entry", :as => "signup_start_code_entry"
  get "new_patient_password_setup/:pt_id" => "sessions#new_patient_password_setup", :as => "new_patient_password_setup"
  put "p_set/:pt_id" => "sessions#password_set", :as => "password_set"



  # flash.now.alert=
  get 'phone/sms_handler' => "phone#sms_handler", :as => "sms_handler"
  get 'after_start_code_web_handler' => "patients#after_start_code_web_handler", :as => "after_start_code_web_handler"

  delete "physician_log_out" => "sessions#destroy_ph_session", :as => "log_out"

  get "physician_log_in" => "sessions#new_physician_session_login", :as => "log_inG"
  post "physician_log_in" => "sessions#new_physician_session_login", :as => "log_inP"

  get "physician_find" => "physicians#create_ph_session", :as => "create_ph_sessionG"
  post "physician_find" => "physicians#create_ph_session", :as => "create_ph_sessionP"
  get "physician_log_in_session" => "physicians#create_ph_session", :as => "create_ph_session"


  get "physician_sign_up" => "physicians#new", :as => "sign_up"
  get "physician_additional_info" => "physicians#physician_additional_info", :as => "physician_additional_info"
  get "welcome_ph_instructions/:physician_id" => "physicians#welcome_ph_instructions", :as => "welcome_ph_instructions"
  get "unarch_pt/:id/:patient_id" => "physicians#unarchive_patient", :as => "unarchive_patient"
  get "physician_account/:physician_id" => "physicians#physician_account", :as => "physician_account"
  get "edit_physician_account/:physician_id" => "physicians#edit_physician_account", :as => "edit_physician_account"
  get "physician_pswd_edit/:physician_id" => "physicians#ph_password_edit", :as => 'ph_password_edit'
  patch "physician_pswd_update/:physician_id" => "physicians#ph_password_update", :as => 'ph_password_update'


  get "login" => "sessions#new", :as => 'get_new_session'
  post "login" => "sessions#create", :as => 'create_session'
  post "login" => "sessions#new", :as => 'post_new_session'

  # physicians GET    /physicians(.:format)                                                         physicians#index
  #                                    POST   /physicians(.:format)                                                         physicians#create
  #                      new_physician GET    /physicians/new(.:format)                                                     physicians#new
  #                     edit_physician GET    /physicians/:id/edit(.:format)                                                physicians#edit
  #                          physician GET    /physicians/:id(.:format)                                                     physicians#show
  #                                    PATCH  /physicians/:id(.:format)                                                     physicians#update
  #                                    PUT    /physicians/:id(.:format)                                                     physicians#update
  #                                    DELETE /physicians/:id(.:format)                                                     physicians#destroy


    delete "patient_log_out" => "sessions#destroy_pt_session", :as => "patient_log_out"
    get "patient_log_in" => "sessions#new_patient_session_login", :as => "patient_log_in"
    get "patient_find" => "sessions#create_pt_session", :as => "patient_geted"
    get "patient_edit/:patient_id" => "patients#patient_edit_limited", :as => "pt_edit"
    get "patient_show/:patient_id" => "patients#patient_show_limited", :as => "pt_show"
    put "patient_update/:patient_id" => "patients#patient_update_limited", :as => "pt_update"
    get "patient_welcome/:patient_id" => "patients#patient_welcome", :as => "patient_welcome"


  get "admin_override_pt_password_edit/:patient_id" => "patients#admin_pt_password_edit", :as => "admin_pt_pass_edit"
  get "admin_override_pt_password_update/:patient_id" => "patients#admin_pt_password_update", :as => "admin_pt_pass_update"
  get "admin" => "admin#index", :as => "admin"
  get "archived_physicians" => "admin#archived_physicians", :as => "archived_physicians"
  get "archived_patients" => "admin#archived_patients", :as => "archived_patients"
  get "active_patients" => "admin#active_patients", :as => "active_patients"
  get "deact_and_arch_pt/:patient_id" => "admin#deactivate_and_archive_patient", :as => "deactivate_and_archive_patient"
  get "react_and_unarch_pt/:patient_id" => "admin#reactivate_and_unarchive_patient", :as => "reactivate_and_unarchive_patient"
  get "archive_a_physician/:physician_id" => "admin#archive_a_physician", :as => "archive_a_physician"
  get "unarchive_a_physician/:physician_id" => "admin#unarchive_a_physician", :as => "unarchive_a_physician"

  post 'phone/test' => 'phone#test'
  post 'log_entries/perform' => 'log_entries#perform'
  resources :physicians do
    resources :patients do
      resources :log_entries
    end
  end

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
  #       get 'toggle'
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
  # Note: This route will make all actions in every controller accessible get GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
