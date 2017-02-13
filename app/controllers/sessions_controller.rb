class SessionsController < ApplicationController

  def new #new_physician_session_login
    if params[:format] == 'physician'
      @ph = true
      # session[:identity_ph] = true
      #  session[:identity_pt] = nil
      return false
    elsif params[:format] == 'patient'
      @pt = true
      # session[:identity_pt] = true
      # session[:identity_ph] = nil
      return false
    else
      flash[:alert] = 'Something went wrong. Pleaes restart your browser and revisit page.'
      redirect_to home_page_path
    end
  end

   def login_allowed_params
     x = params.require(:session).permit(:email, :password)
   end

   def pt_login_allowed_params
     x = params.permit(:password, :utf8, :authenticity_token, :phone_number, :commit, :pt)
   end

   def password_set_params
     params.require(:patient).permit(:password, :password_confirmation)
   end


    def create
           if params[:ph]
              ph = Physician.find_by email: params[:session][:email]
              if ph.authenticate(params[:session][:password]) && (ph.state != (nil || ""))  && (ph.first_name != (nil || "")) && (ph.last_name != (nil || "")) && (ph.specialty != (nil || ""))
                session[:physician_id] = ph.id
                session[:identity_ph] = nil
                redirect_to physician_patients_path(session[:physician_id])
              elsif ph.authenticate(params[:session][:password]) && ((ph.state == (nil || "")) || (ph.first_name == (nil || "")) || (ph.last_name == (nil || "")) || (ph.specialty == (nil || "")))
                session[:physician_id] = ph.id
                session[:identity_ph] = nil
                redirect_to physician_additional_info_path(:id => ph.id)
                flash[:alert] = 'We still need a few more details about you before you start!'
              else
                redirect_to get_new_session_path(:format => 'physician')
                flash[:alert] = 'Incorrect credentials'
              end
           elsif params[:pt]
              pt = Patient.find_by phone_number: params[:session][:phone_number]
              if pt && pt.authenticate(params[:session][:password])
                session[:patient_id] = pt.id
                session[:identity_pt] = nil
                redirect_to physician_patient_log_entries_path(:patient_id => pt.id, :physician_id => pt.physician_id)
              else
                redirect_to get_new_session_path(:format => 'patient')
                flash[:alert] = 'Incorrect credentials'
              end
          else
            redirect_to get_new_session_path(:format => 'patient')
            flash[:alert] = 'Something went wrong! Try loggin in again.'
         end
       end

    def destroy_ph_session
          session[:physician_id] = nil
          redirect_to home_page_path, notice: "Logged out!"
          return false
    end

    # em = params[:email]
    #    if em
    #      #redirect_to create_ph_sessionG_path(allowed_params_login)
    #    end
    #  end

  def new_patient_session_login
        session[:first_login_restriction] = true
  end



     def signup_start_code_entry
     end

     def signup_code_verification
               pt_phone_number = Patient.where(:phone_number => params[:phone_number]).first
               pt_code = Patient.where(:start_code => params[:start_code]).first
        unless pt_phone_number == nil || pt_code == nil
                 if pt_phone_number.signup_status == "returning"
                   redirect_to get_new_session_path(:format => 'patient')
                   flash[:alert] = 'You already have setup an account. Please login here.'
                 elsif pt_code.phone_number == pt_phone_number.phone_number
                   session[:start] = pt_code.id
                   redirect_to new_patient_password_setup_path(:pt_id => pt_code.id)
                 elsif pt_code.phone_number && !pt_phone_number.phone_number
                   redirect_to signup_start_code_entry_path #flash[:alert] = "Hdmon does not recognize the start code you provided."
                 elsif !pt_code.phone_number && pt_phone_number.phone_number
                   redirect_to signup_start_code_entry_path #flash[:alert] = "Hdmon does not recognize the phone number you provided."
                 end
        else
            redirect_to signup_start_code_entry_path #flash[:alert] = "Hdmon does not recognize the phone number or start code you provided."
        end
      end

     def new_patient_password_setup
       @patient = Patient.find(params[:pt_id])
       session[:patient_id]
     end

       def password_set
         @patient = Patient.find(params[:pt_id])
         if (session[:start]).to_s == @patient.id.to_s
           if @patient.update_attributes(password_set_params)
             session[:start] = nil
             redirect_to patient_welcome_path(:patient_id => @patient.id)
             return false
           else
             redirect_to new_patient_password_setup_path(:pt_id => @patient.id)
             return false
           end

         else
           redirect_to home_page_path
           return false
         end
       end


     def create_pt_session
       pt = Patient.where(:phone_number => params[:phone_number]).first
       if pt
          ph = Physician.find(pt.physician_id)
          if ph.id == nil && ph.arch_id
            render "doctor_deactivated"
            return false
          end
       end
       if pt
         if pt.signup_status == "returning"
           if pt && pt.authenticate(pt_login_allowed_params)
             session[:patient_id] = pt.id
             redirect_to physician_patient_log_entries_path(ph, pt), notice: "Logged in!"
             return false
           else
             render "new_patient_session_login", :notice => "Invalid email or password"
             return false
           end
         elsif pt.signup_status == "new"
           if session[:first_login_restriction]
             session[:first_login_restriction] = nil
             redirect_to new_patient_start_code_entry_path, :notice => "Because you are a new patient, please sign up here."
             return false
           else
             session[:patient_id] = pt.id
             pt.signup_status = "returning"
             pt.save(:validate => false)
             session[:start] = nil
             redirect_to patient_welcome_path(:patient_id => pt.id)
             return false
           end
         else
           redirect_to home_page_path
           return false
         end
       else
         redirect_to patient_log_in_path
         return false
       end

     end



     def destroy_pt_session
       session[:patient_id] = nil
       redirect_to home_page_path, notice: "Logged out!"
       return false
     end







end
