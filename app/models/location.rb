class Location < ActiveRecord::Base
  scope :within_lat_range, lambda { |min_lat, max_lat| where(lat: (min_lat..max_lat)) }
  scope :within_long_range, lambda { |min_long, max_long| where(long: (min_long..max_long)) }

  validates :lat, :long, presence: true, numericality: {
    greater_than: -180,
    less_than: 180
  }

  def coords
    [lat, long]
  end
end
