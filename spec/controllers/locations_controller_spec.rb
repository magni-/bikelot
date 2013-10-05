require 'spec_helper'

describe LocationsController do 
 describe 'POST create' do
  it "creates location for valid params" do
    expect{
      post :create, location: {lat:40, long: 10}, format: :json
    }.to change{Location.count}.by(1)
  end
  it "responds with success true json" do
    post :create, location: {lat:40, long: 10}, format: :json
    expect(response.body).to have_content ({success: true}.to_json)
  end
  it "responds with success false with invalid params" do
    post :create, location: {lat:91, long:10}
    expect(response.body).to have_content ({success: false}.to_json)
  end
 end 
end
