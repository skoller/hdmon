class LogEntriesController < ApplicationController

  include Delayed::RecurringJob
  run_every 1.minute
  run_at '1:34pm'
  timezone 'US/Pacific'
  queue 'slow-jobs'

  before_action :authenticate_user
  before_action :restrict_access_to_relevant_pages

  def index
    if session[:physician_id]
      @physician_or_admin_view = true
    elsif session[:patient_id]
      @patient_view = true
    end
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entries = @patient.log_entries.order('date ASC')
    respond_to do |format|
        format.html
        format.pdf do
          pdf = LogPdf.new(@patient)
          send_data pdf.render, filename: "#{@patient.last_name.capitalize}#{@patient.first_name.split(//)[0].capitalize}_#{Date.today}_EatingLog.pdf",
                                type: "application/pdf",
                                disposition: "inline"


        end
    end
  end

  def show
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
  end

  def new
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.build
  end

  def edit
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
  end

  def create
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.build(params[:log_entry])
    if @log_entry.save
      redirect_to physician_patient_log_entry_path(@ph, @patient, @log_entry), notice: 'Log Entry was successfully created.'
      return false
    else
      render action:'new'
      return false
    end
  end

  def update
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])

    if @log_entry.update_attributes(params[:log_entry])
      redirect_to physician_patient_log_entry_path(@ph, @patient, @log_entry), notice: 'Log entry was successfully updated.'
      return false
    else
      render action: "edit"
      return false
    end
  end

  def destroy
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
    @log_entry.destroy
    redirect_to physician_patient_log_entries_path(@ph, @patient)
    return false
  end



  def perform
    number_to_send_to = '3108090426'
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
                 :body => "You have communicated with HdMon"
               )
  end

end
