require 'spec_helper'

describe LocationsController do 
  describe 'POST create' do
    it 'should create location for valid params' do
      expect {
        post :create, location: {latitude: 40, longitude: 10, spots: 1}, format: :json
      }.to change {
        Location.count
      }.by(1)
    end

    it 'should respond with success true json' do
      post :create, location: {latitude: 40, longitude: 10, spots: 1}, format: :json
      expect(response.body).to have_content ({success: true}.to_json)
    end

    it 'should respond with success false with invalid params' do
      post :create, location: {latitude: 181, longitude: 10, spots: 1}
      expect(response.body).to have_content ({success: false}.to_json)
    end

    it 'should create a new location with score 1' do
      post :create, location: {latitude: 32, longitude: -13, spots: 1}, format: :json
      expect(Location.last.score).to eq(1)
    end

    it 'should only increment the score rather than create a duplicate entry for close coordinates' do
      expect {
        post :create, location: {latitude: 32, longitude: -13, spots: 1}, format: :json
        post :create, location: {latitude: 32, longitude: -13.0001, spots: 1}, format: :json
      }.to change {
        Location.count
      }.by(1)
      expect(Location.last.score).to eq(2)
    end

    it 'should not create anything for new coordinates with -1 spots' do
      expect {
        post :create, location: {latitude: 32, longitude: -13, spots: -1}, format: :json
      }.to_not change {
        Location.count
      }  
    end

    it 'should decrement the score when similar coordinates are passed with -1 spots' do
      expect {
        post :create, location: {latitude: 32, longitude: -13, spots: 1}, format: :json
        post :create, location: {latitude: 32, longitude: -13.0001, spots: -1}, format: :json
      }.to change {
        Location.count
      }.by(1)
      expect(Location.last.score).to eq(0)
    end
  end
end
