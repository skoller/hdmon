class PhysiciansController < ApplicationController
  #wrap_parameters :physician, include: [:id, :email, :password_digest]
  
  #before_action :authenticate_user, :except => [:new, :create, :create_ph_session, :allowed_params]
  #ActionController::Parameters.permit_all_parameters = true
  
  def new
    @physician = Physician.new
    @no_session_format = true
    session[:physician_id] = nil
    session[:patient_id] = nil 
  end

  def create
    @physician = Physician.new(ph_signup_params)
    #byebug
    #params = ActionController::Parameters.new(email: @physician.email, password: @physician.password, password_confirmation: @physician.password_confirmation)
    #@physician.password_digest = BCrypt::Password.create(params[:password])
    @physician.save
      if @physician.password_digest && @physician.email
      session[:physician_id] = @physician.id
      redirect_to physician_additional_info_path(:id => @physician.id)
    else
      render 'new'
      return false
    end
  end














  def create_ph_session
    ph = Physician.find_by_email(params[:email])
    unless ph == nil
            if (ph.email == 'dev@bvl.com') && ph.authenticate(params[:password]) && ph.state
              session[:physician_id] = 1
              redirect_to admin_path(ph) # established admin account login success
              
            elsif (ph.email == 'dev@bvl.com') && ph.authenticate(params[:password]) && (ph.state == nil)
                session[:physician_id] = 1
                redirect_to physician_additional_info_path(:id => ph.id) #admin account setup second step
                
            elsif (ph.email != 'dev@bvl.com') && ph.authenticate(params[:password]) && ph.state
              session[:physician_id] = ph.id
              redirect_to physician_patients_path(ph) #established physician account login success
             
            elsif (ph.email != 'dev@bvl.com') && ph.authenticate(params[:password]) && (ph.state == nil)
              session[:physician_id] = ph.id
              redirect_to physician_additional_info_path(:id => ph.id)   #physician account setup second step
               
            elsif !ph.authenticate(params[:password])
              flash.now[:danger] = 'incorrect login credentials 1'
              render "sessions/new_physician_session_login" #** remember to add error message stating incorrect password for login                
            end
    else
      flash.now[:danger] = 'email not recognized'
      #render "sessions/new_physician_session_login" #** remember to add error message stating incorrect password or email for login
    end
    
  end


  def physician_additional_info
     if (params[:id] == session[:physician_id].to_s)
       @ph = Physician.find(params[:id])
     else
       patient_restriction
     end
   end


  def physician_account
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      if (session[:physician_id] == 1)
        @admin_ph = true
        @ph = Physician.find(params[:physician_id])
      elsif ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s))
        @normal_ph = true
        @ph = Physician.find(params[:physician_id])
      end
    else
      patient_restriction
    end
  end

  def edit_physician_account
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      if (session[:physician_id] == 1)
        @admin_ph = true
        @ph = Physician.find(params[:physician_id])
      elsif ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s))
        @normal_ph = true
        @ph = Physician.find(params[:physician_id])
      end
    else
      patient_restriction
    end
  end

    # if (session[:physician_id].to_s && (params[:physician_id] == session[:physician_id].to_s)) || (session[:physician_id] == 1)
    #   if session[:physician_id] == 1
    #     @ph = Physician.find(params[:id])
    #   else
    #     @ph = Physician.find(params[:physician_id])
    #   end
    #   if (@ph.update_attributes(params[:physician]))
    #     redirect_to physician_account_path(:physician_id => @ph.id), :notice => "Your updates were successful."
    #     return false
    #   else
    #     redirect_to :action => 'edit_physician_account'
    #     return false
    #   end

  def update
    if (session[:physician_id].to_s && (params[:id] == session[:physician_id].to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:id])
      if @ph.first_name == nil
        @ph.update_attributes(ph_signup2_params)
        redirect_to welcome_ph_instructions_path(:physician_id => @ph.id)
        return false
      elsif @ph.first_name
        if @ph.update_attributes(ph_signup2_params)
          redirect_to physician_account_path(:physician_id => @ph.id), :notice => "Your updates were successful."
          return false
        else
          redirect_to :action => 'edit_physician_account'
          return false
        end
      else
        redirect_to :action => 'physician_additional_information'
        return false
      end
    else
      patient_restriction
    end
  end

  def ph_password_edit
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:physician_id])  
    else
      patient_restriction
    end
  end


  def ph_password_update
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @ph = Physician.find(params[:physician_id])
      if (@ph.update_attributes(ph_signup_params))
        redirect_to physician_patients_path(:physician_id => @ph.id), :notice => "Your password update was successful."
        return false
      else
        redirect_to :action => 'ph_password_edit'
        return false
      end
    else
      patient_restriction
    end
  end


  def deactivate_pt_message
    @ph = Physician.find(params[:physician_id])
    @pt = Patient.find(params[:patient_id])
  end
  
  def deactivate_ph_message
    @ph = Physician.find(params[:physician_id])
  end
  
  def signup_part2
    @ph = Physician.find(params[:id])
    @ph.attributes = ph_signup2_params
    if @ph.save
      redirect_to welcome_ph_instructions_path(:physician_id => @ph.id), :notice => "Your information saved."
      return false
    else
      redirect_to :action => 'physician_additional_information'
      return false
    end
  end

 
  
  def welcome_ph_instructions
    @ph = Physician.find(params[:physician_id])
  end
  
  def unarchive_patient
    if ((session[:physician_id]).to_s && ((params[:id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
    @pt = Patient.find(params[:patient_id])
    @ph = Physician.find(@pt.physician_id)
    @pt.archive = nil
    @pt.save(:validate => false)
    redirect_to physician_patients_path(@ph, @pt)
    return false
    else
      patient_restriction
    end
    
  end
  
  
def pt_archive_index
  @ph = Physician.find(params[:physician_id])
  @pt_arch = @ph.patients.where(:archive => true).all
end


private

def ph_signup_params
    params.require(:physician).permit(:email, :password, :password_confirmation)
end
def ph_signup2_params
  params.require(:physician).permit(:first_name, :last_name, :state, :specialty, :email)
end 

end