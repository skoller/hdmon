class LogEntriesController < ApplicationController


  # before_action :authenticate_user
  # before_action :restrict_access_to_relevant_pages

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
    @patient = Patient.find(params[:patient_id])
    @ph = @patient.physician_id
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

  def log_entry_allowed_params
    params.require(:log_entry).permit(:id, :date, :location, :food, :binge, :vomit,
    :laxative, :personal_notes, :password)
  end

  def log_entry_params_for_destroy
    params.permit(:id, :patient_id, :physician_id)
  end

  def patient_id_param
    params.permit(:patient_id)
  end

  def create
    if current_patient
        @patient = current_patient
        @ph = Physician.where(:id => current_patient.physician_id)
    else
        @patient = Patient.find(patient_id_param)
        @ph = Physician.where(:id => @patient.physician_id)
    end
    @log_entry = @patient.log_entries.build(log_entry_allowed_params)
    @log_entry.patient_id = current_patient.id
    @log_entry.save
    if @log_entry
      redirect_to physician_patient_log_entry_path(@ph, @patient, @log_entry), notice: 'Log Entry was successfully created.'
      return false
    else
      render action:'new'
      return false
    end
  end

  def update
    @ph = Physician.find(params[:physician_id])
    @patient = Patient.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])

    if @log_entry.update_attributes(log_entry_allowed_params)
      redirect_to physician_patient_log_entry_path(@ph, @patient, @log_entry), notice: 'Log entry was successfully updated.'
      return false
    else
      render action: "edit"
      return false
    end
  end

  def destroy
    @ph = Physician.find(params[:physician_id])
    @patient = Patient.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
    @log_entry.destroy
    redirect_to physician_patient_log_entries_path(@ph, @patient)
    return false
  end





end
