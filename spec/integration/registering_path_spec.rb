require 'rails_helper'

describe "Registering a path", :type => :request do

  describe "for a path that has not previously been registered" do

    it "should reserve a new path and return json details" do
      put_json "/paths/foo/bar", {"publishing_app" => "publisher"}

      expect(response.status).to eq(201)
      data = JSON.parse(response.body)
      expect(data["path"]).to eq("/foo/bar")
      expect(data["publishing_app"]).to eq("publisher")

      reservation = Reservation.find_by_path("/foo/bar")
      expect(reservation).to be
      expect(reservation.publishing_app).to eq("publisher")
    end

    it "should return 422 and error details for an invalid request" do
      put_json "/paths/foo/bar", {"publishing_app" => ""}

      expect(response.status).to eq(422)
      data = JSON.parse(response.body)
      expect(data["errors"]).to eq({"publishing_app" => ["can't be blank"]})

      expect(Reservation.find_by_path("/foo/bar")).to be_nil
    end

    it "should handle non-ascii paths" do
      # URI encoded 'foo-€45-bar'
      put_json "/paths/foo-%E2%82%AC45-bar", {"publishing_app" => "publisher"}

      expect(response.status).to eq(201)
      data = JSON.parse(response.body)
      expect(data["path"]).to eq("/foo-%E2%82%AC45-bar")
      expect(data["publishing_app"]).to eq("publisher")

      reservation = Reservation.find_by_path("/foo-%E2%82%AC45-bar")
      expect(reservation).to be
      expect(reservation.publishing_app).to eq("publisher")
    end
  end

  describe "for a path that has previously been registerd" do
    before :each do
      @reservation = create(:reservation, :path => "/foo/bar", :publishing_app => "publisher")
    end

    it "should be successful if the publishing_app matches" do
      put_json "/paths/foo/bar", {"publishing_app" => "publisher"}

      expect(response.status).to eq(200)
    end

    it "should 409 with an error if the publishing_app doesn't match" do
      put_json "/paths/foo/bar", {"publishing_app" => "whitehall"}

      expect(response.status).to eq(409)
      data = JSON.parse(response.body)
      expect(data["errors"]).to eq({"path" => ["is already reserved by the 'publisher' app"]})

      @reservation.reload
      expect(@reservation.publishing_app).to eq("publisher")
    end
  end

  it "returns a 400 for a request with invalid json" do
    put "/paths/foo", "I'm not json", "CONTENT_TYPE" => "application/json"

    expect(response.status).to eq(400)
    data = JSON.parse(response.body)
    expect(data["errors"]).to eq({ "request_body" => ["invalid JSON: 757: unexpected token at 'I'm not json'"] })
  end
end
