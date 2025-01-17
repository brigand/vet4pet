# Chipotle Software (c) 2015-2016 MIT License
class AppointmentsController < ApplicationController

  #before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments
  def index
  end

  #GET fulfill_form
  def fulfill_form
    response = Hash.new
    response[:owners] = User.all_users(2)
    response[:docs]   = User.all_users(3)
    return render json: response
  end
  
  #GET ActionCable
  def broadcast
    appos = Appointment.to_react
    ActionCable.server.broadcast 'snippets', appos: appos
  end
  
  # POST /appointments/get_one_appo
  def get_one_appo
    # logger.debug "### PARAMS in get_appos in appointments ##################>>>> #{params[:id]}"
    # return render json: params
    response = Hash.new
    response[:appo]   = Appointment.get_one(params[:id])
    response[:owners] = User.all_users(2)
    response[:docs]   = User.all_users(3)
    response[:pets]   = Pet.get_pets(params[:id], false)
    return render json: response
  end
  
  # POST /appointments/get_appos
  def get_appos
    #logger.debug "### PARAMS in get_appos in appointments ##################>>>> #{params.to_json}"
    # return render json: params
    appos = Appointment.get_all(params[:active])
    return render json: appos
  end

  # POST /appointments/get_data
  # Owners array to populate dinamically owners data list 
  def get_data
    owner = params[:ovalue]
    results = User.where("(fname ~ '#{owner}' OR lname ~ '#{owner}') AND group_id=2").select(:id, :fname, :lname)
    logger.debug "### get_data in appointments #####################>>>> #{params.to_json} "
    users = results.map do |r|
      {value: r.id, name: "#{r.lname} #{r.fname}" }
    end
    return render json: users.to_json
  end

  # POST /appointments
  def create
    # return render json: params
   
    new_params = Appointment.order_appointment(params)
    result     = Appointment.create(new_params)  
    if result
      return render json: {status: 'ok', code: 202}
    else
      return render json: {status: 'error', code: 502}
    end
  end

  # PATCH/PUT /appointments/1
  def update
      logger.debug "### Data in PATCH create#appointments #####################>>>> #{params.to_json} "
      # {"id":"9","date":"2016-03-17 07-00-00","reminder":true,"owner":"Grimms","petname":"Babby","reason":"Vaccines","controller":"appointments","action":"update","appointment":{"id":9,"reminder":true}} 

      return render json: params
      if @appointment.update(params)
        render json: {status: :ok, message: 'Appointed updated', code: 00} 
      else
        render json: {status: :failed, errors: @appointment.errors, message: :unprocessable_entity, code: 044} 
      end
  end

  # GET /appointments/appo_delete/1
  def appo_delete
    appos = Appointment.to_react
    return render json: appos
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy
    return render json: {status: :ok, message: 'Appointed deleted', code: 00}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      return 
      params.require(:appointment).permit(:scheduled_time, :pet_id, :owner_id, :reminder, :reason_for_visit, :doctor_id, :active, :id)
    end
end
