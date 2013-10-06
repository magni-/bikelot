class LocationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def index
    @locations = Location.all
    @locations = Location.active.within_lat_range(params[:min_lat], params[:max_lat]).within_long_range(params[:min_long], params[:max_long]) if [:min_lat, :max_lat, :min_long, :max_long].all? {|s| params.key? s}

    render json: @locations, only: [:latitude, :longitude, :spots]
  end

	# POST
  # params: latitude REQ, longitude REQ, spots DEF 1
  def create
    if Location.find_or_create_by_coords(location_params)
      render json: {success: true}
    else
      render json: {success: false}
    end
	end

  private
  def location_params
    params.require(:location).permit(:latitude, :longitude, :spots)
  end
end
