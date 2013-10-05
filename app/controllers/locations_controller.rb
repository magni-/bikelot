class LocationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def index
    @locations = Location.all
    @locations = Location.within_lat_range(params[:min_lat], params[:max_lat]).within_long_range(params[:min_long], params[:max_long]) if [:min_lat, :max_lat, :min_long, :max_long].all? {|s| params.key? s}

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
