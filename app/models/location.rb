class Location < ActiveRecord::Base
  scope :active, -> { where('score > 0') }
  scope :within_lat_range, ->(min_lat, max_lat) { where(latitude: (min_lat..max_lat)) }
  scope :within_long_range, ->(min_long, max_long) { where(longitude: (min_long..max_long)) }

  validates :latitude, :longitude, presence: true, numericality: {
    greater_than: -180,
    less_than: 180
  }

  validates :spots, presence: true, numericality: {
    greater_than: -1,
    less_than: 4
  }

  validates :score, presence: true

  reverse_geocoded_by :latitude, :longitude


  def coords
    [latitude, longitude]
  end

  def inc_score
    self.score += 1
  end

  def dec_score
    self.score -= 1
  end

  class << self
    def find_by_coords(coords)
      coords = [coords[:latitude], coords[:longitude]]
      unless (locs = Location.near(coords, 0.05, {units: :km})).nil?
        locs.first
      end
    end

    def find_or_create_by_coords(location_params)
      if location = Location.find_by_coords(location_params)
        if location_params[:spots].to_i == -1
          location.dec_score
        else
          location.spots = location_params[:spots] || 1
          location.inc_score
        end
      else
        unless location_params[:spots].to_i == -1
          location = Location.new({spots: 1}.merge(location_params.merge({score: 1})))
        end
      end
      location.save if location
    end
  end
end
