class LocationsController < ApplicationController

	#POST
  #params: lat, long
  def create
    location = Location.new(location_params)
    if location.save
      render json: {success: true}, status: :created
    else
      render json: {success: false}
    end
	end
  
  private
  def location_params
    params.require(:location).permit(:lat, :long)
  end
end
