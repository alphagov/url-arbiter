require 'rails_helper'

describe "Requesting details of a path", :type => :request do

  it "returns details of the path as JSON" do
    reservation = create(:reservation, :path => "/foo/bar")

    get "/paths/foo/bar"

    expect(response.status).to eq(200)
    expect(response.content_type).to eq("application/json")

    data = JSON.parse(response.body)
    expect(data["path"]).to eq("/foo/bar")
    expect(data["publishing_app"]).to eq(reservation.publishing_app)
  end

  it "returns 404 for a path that has not been reserved" do
    get "/paths/non-existent"
    expect(response.status).to eq(404)
  end

  it "should handle non-ascii paths" do
    # URI encoded 'foo-€45-bar'
    reservation = create(:reservation, :path => "/foo-%E2%82%AC45-bar")

    get "/paths/foo-%E2%82%AC45-bar"

    expect(response.status).to eq(200)
    expect(response.content_type).to eq("application/json")

    data = JSON.parse(response.body)
    expect(data["path"]).to eq("/foo-%E2%82%AC45-bar")
    expect(data["publishing_app"]).to eq(reservation.publishing_app)
  end
end
