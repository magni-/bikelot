class LocationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def index
    @locations = Location.all
    @locations = Location.active.within_lat_range(params[:min_lat], params[:max_lat]).within_long_range(params[:min_long], params[:max_long]) if [:min_lat, :max_lat, :min_long, :max_long].all? {|s| params.key? s}

    render json: @locations, only: [:latitude, :longitude]
  end

	# POST
  # params: latitude REQ, longitude REQ, spots DEF 1
  def create
    if location = Location.find_by_coords(location_params)
      if params[:location][:spots].to_i == -1
        location.dec_score
      else
        location.spots = params[:location][:spots] || 1
        location.inc_score
      end
    else
      if params[:location][:spots].to_i == -1
        skip = true
      else
        location = Location.new({spots: 1}.merge(location_params.merge({score: 1})))
      end
    end
    puts location.inspect
    if skip || location.save
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
