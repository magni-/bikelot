class Location < ActiveRecord::Base
	validates :lat, :long, presence: true, numericality: {
    greater_than: -90,
    less_than: 90
  }
end
