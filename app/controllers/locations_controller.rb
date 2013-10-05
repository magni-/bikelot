class LocationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def index
    @locations = Location.all
    render json: @locations, only: [:lat, :long]
  end

	#POST
  #params: lat, long
  def create
    location = Location.new(location_params)
    if location.save
      render json: {success: true}
    else
      render json: {success: false}
    end
	end

  private
  def location_params
    params.require(:location).permit(:lat, :long)
  end
end
