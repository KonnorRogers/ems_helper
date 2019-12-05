class HospitalsController < ApplicationController
  # GET /hospitals(.:format)
  # display all hospitals
  def index
    @hospitals = Hospital.all
  end

  # POST /hospitals/(.:format)
  def create
    # TODO: Create a login for this
    # @hospital = Hospital.new(hospital_params)
  end

  # GET /hospitals/new(.:format)
  # Add a new hospital
  def new
    @hospital = Hospital.new
  end

  # GET /hospitals/:id/edit(.:format)
  def edit
    # TODO: Create a login for this
    # @hospital = Hospital.find(params[:id]).
  end

  # GET /hospitals/:id(.:format)
  def show
    @hospital = Hospital.find(params[:id])
  end

  # (PATCH | PUT) /hospitals/:id(.:format)
  def update
    # TODO: Create a login for this
    # @hospital = Hospital.find(params[:id])
    # if @hospital.update_attributes(hospital_params)
    #   flash[:success] = 'Hospital updated'
    #   redirect_to @hospital
    # else
    #   flash.now[:error] = 'Hospital not updated'
    #   render 'edit'
    # end
  end

  # DELETE /hospitals/:id(.:format)
  def destroy
    # TODO: Create a login to be able to use this
    # Hospital.find(params[:id]).destroy
  end
end
