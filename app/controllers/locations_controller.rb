class LocationsController < ApplicationController

  #GET
  def index
    
  end

	#POST
  #params: lat, long
  def create
    logger.info params.inspect
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
