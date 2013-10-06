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

  def self.find_by_coords(coords)
    coords = [coords[:latitude], coords[:longitude]]
    unless (locs = Location.near(coords, 0.05, {units: :km})).nil?
      locs.first
    end
  end
end
