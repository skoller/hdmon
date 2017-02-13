class PatientsController < ApplicationController

  before_action :authenticate_user

  def index
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:physician_id])
      @pt = @ph.patients.where(:archive => nil).all
      @patients = @pt.sort_by { |pt| pt.last_name.downcase }
      @physician_or_admin_view = true
    else
      patient_restriction
    end
  end

  def archive
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:physician_id])
      @patient = Patient.find(params[:id])
      @patient.activity_history = @patient.activity_history + "  >>>>>> Archived by #{@ph.email} on #{DateTime.now.to_time.strftime('%c')}"
      @patient.archive = true
      @patient.phone_number = ""
      if @patient.save(:validate => false)
        redirect_to pt_archive_index_path(:physician_id => @ph.id)
        return false
      else
        redirect_to physician_patients_path(@ph)
        return false
      end
    else
      patient_restriction
    end
  end

  def index_pt_archive
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:physician_id])
      @pt = @ph.patients.where(:archive => true).all
      @patients = @pt.sort_by { |pt| pt.last_name.downcase }
    else
      patient_restriction
    end
  end

    def show
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @ph = Physician.find(params[:physician_id])
        @patient = Patient.find(params[:id])
      else
        patient_restriction
      end
    end

    def new
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @ph = Physician.find(params[:physician_id])
        @patient = @ph.patients.build
      else
        patient_restriction
      end
    end

    def edit
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @patient = Patient.find(params[:id])
        @ph = Physician.find(params[:physician_id])
      else
        patient_restriction
      end
    end

    def create
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @ph = Physician.find(params[:physician_id])
        @patient = @ph.patients.build(allowed_pt_params)
        @patient.activity_history = "*****Account created by #{@ph.email} on #{DateTime.now.to_time.strftime('%c')}"
        @patient.signup_status = "new"
        @patient.start_code = rand(999999).to_s.center(6, rand(9).to_s)
        @password_random_suffix = rand(999999).to_s.center(6, rand(9).to_s)
        if @patient.save
          session[:patient_start] = @patient.id
          number_to_send_to = @patient.phone_number
          account_sid = 'AC0e331b7fa11f13be73a32e5311a74969'
          auth_token = 'e948aaf8caad373ae54918c175fd8786'
          twilio_phone_number = "3104992061"

          @twilio_client = Twilio::REST::Client.new account_sid, auth_token
          @twilio_client.account.messages.create(
                       :from => "+1#{twilio_phone_number}",
                       :to => number_to_send_to,
                       :body => "Congratulations!"
                     )
                 @twilio_client.account.messages.create(
                       :from => "+1#{twilio_phone_number}",
                       :to => number_to_send_to,
                       :body => "Glad to see you have joined HdMon! HdMon will text you every evening between 8-9pm to ask if you had a headache that day. Just respond to the texts and that's it! Your doctor will be able to see your responses at your next visit to help guide your treatment. If you would like to login online to view your log of responses, go to wwww.hdmon etc, select signup, and enter start code: #{@patient.start_code} complete the account setup."
                     )
          redirect_to physician_patients_path
          return false
        else
          render :action => "new"
          return false
        end
      else
        patient_restriction
      end
    end


    def update
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @ph = Physician.find(params[:physician_id])
        @patient = Patient.find(params[:id])
        @patient.signup_status = "returning"
        @patient.save(:validate => false)

        if @patient.update_attributes(allowed_pt_params)
          redirect_to physician_patient_path
          return false
        else
          render :action =>"edit"
          return false
        end
      else
        patient_restriction
      end
    end


    def destroy
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @patient = Patient.find(params[:id])
        @ph = Physician.find(params[:physician_id])
        @patient.destroy
        redirect_to physician_patients_url(@ph)
        return false
      else
        patient_restriction
      end
    end

    def admin_pt_password_edit
      if session[:physician_id] == 1
        @patient = Patient.find(params[:patient_id])
        @ph = Physician.find(@patient.physician_id)
      else
        redirect_to home_page_path
        return false
      end
    end

    def admin_pt_password_update
      if session[:physician_id] == 1
        @patient = Patient.find(params[:patient_id])
        @ph = Physician.find(@patient.physician_id)
        @patient.signup_status = "returning"
        @patient.save(:validate => false)

        if @patient.update_attributes(allowed_pt_params)
          redirect_to physician_patient_path(@ph, @patient), :notice => "The patient's password was successfully reset"
          return false
        else
          render :action =>"admin_pt_password_edit"
          return false
        end
      else
        redirect_to home_page_path
        return false
      end
    end

    def patient_welcome
      @pt = Patient.find(params[:patient_id])
      @ph = Physician.find(@pt.physician_id)
      if @pt
        @pt.signup_status = 'returning'
        if @pt.save
        elsif
          redirect_to new_patient_password_setup_path(@pt.id => :pt_id)
        end
      else
          redirect to home_page_path
          flash[:notice] = 'Something went wrong!'
      end
    end


    ############# paitent-specific methods #######

    def patient_edit_limited
      if (session[:patient_id]).to_s && (params[:patient_id] == (session[:patient_id]).to_s)
        @patient = Patient.find(params[:patient_id])
        @ph = Physician.find(@patient.physician_id)
      else
        physician_restriction
      end
    end

    def patient_show_limited
      if (session[:patient_id]).to_s && ((params[:patient_id]) == (session[:patient_id]).to_s)
        @patient = Patient.find(params[:patient_id])
        @ph = Physician.find(@patient.physician_id)
      else
        physician_restriction
      end
    end

    def patient_update_limited
      if (session[:patient_id]).to_s && ((params[:patient_id]) == (session[:patient_id]).to_s)
        @patient = Patient.find(params[:patient_id])
        @ph = Physician.find(@patient.physician_id)
        @patient.signup_status = "returning"
        @patient.save(:validate => false)
        if @patient.update_attributes(allowed_pt_params)
          redirect_to pt_show_path(allowed_pt_params)
          return false
        else
          render :action => "patient_edit_limited"
          return false
        end
      else
        patient_restriction
      end
    end

private
def allowed_pt_params
  params.require(:patient).permit(:id, :patient_id, :first_name, :last_name, :dob, :diagnosis, :phone_number, :sex, :password, :password_confirmation)
end

  end
