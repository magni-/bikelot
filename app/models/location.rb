class Location < ActiveRecord::Base
	acts_as_gmappable lat: :lat, lng: :long

  attr_accessor :gmaps, :street, :city, :country

  validates :lat, :long, presence: true, numericality: {
    greater_than: -90,
    less_than: 90
  }

  def gmaps4rails_address
    #describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{self.street}, #{self.city}, #{self.country}"
  end
end
