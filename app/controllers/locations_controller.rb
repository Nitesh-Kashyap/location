class LocationsController < ApplicationController

  include Response
  include ExceptionHandler

  # skipped authentication for API end points and home page
  skip_before_action :authenticate_user!, only: %i[home individual_location all_locations]
  before_action :find_locations, only: %i[home index all_locations]
  before_action :set_location, only: %i[show edit update destroy individual_location]

  def home
  end

  def index
  end

  def show 
  end

  def individual_location
    if @location.image.attached? 
      @location_with_images =  @location.as_json.merge(
                      images_path: @location.image.map { |i| url_for(i) })
      json_response(@location_with_images)
    else 
      json_response(@location)
    end 
  end

  def all_locations
    json_response(@locations)
  end

  def copy
    CopyLocationJob.perform_later(params[:location_id], current_user.id)
    flash[:success] = "Process started to copy Successfully!"
    redirect_to locations_path
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      flash[:success] = "Created Successfully!"
      redirect_to locations_path
    else
      flash[:error] = @location.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      flash[:success] = "Updated Successfully!"
      redirect_to locations_path
    else
      flash[:error] = @location.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    if @location.destroy
      flash[:success] = "Deleted Successfully!"
    else
      flash[:error] = @location.errors.full_messages.join(", ")
    end
    redirect_to locations_path
  end

  private

  def location_params
    params.require(:location).permit(:name, :description, :address, :latitude, :longitude, image: []).merge!(user_id: current_user.id)
  end

  def set_location
    id = params[:location_id].presence || params[:id]
    @location = Location.find_by(id: id)
  end

  def find_locations
    if user_signed_in?
      @locations = Location.where(user_id: current_user).order(id: :desc)
    else
      @locations = Location.order(id: :desc)
    end
  end

end
