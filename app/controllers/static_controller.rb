class StaticController < ApplicationController
  def index
    @json = Location.all
  end
end
