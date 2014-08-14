require 'rails_helper'

RSpec.describe Reservation, :type => :model do
  describe "validations" do
    before :each do
      @reservation = build(:reservation)
    end

    describe "on path" do

      it "is required" do
        @reservation.path = ''
        expect(@reservation).not_to be_valid
        expect(@reservation.errors[:path].size).to eq(1)
      end

      it "is a valid absolute URL path" do
        @reservation.path = "not a URL"
        expect(@reservation).not_to be_valid
        expect(@reservation.errors[:path].size).to eq(1)
      end

      it "is unique" do
        create(:reservation, :path => "/foo/bar")
        @reservation.path = "/foo/bar"
        expect(@reservation).not_to be_valid
        expect(@reservation.errors[:path].size).to eq(1)
      end

      it "has a db level uniqueness constraint" do
        create(:reservation, :path => "/foo/bar")
        @reservation.path = "/foo/bar"
        expect {
          @reservation.save! :validate => false
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end

    describe "on publishing_app" do
      it "is required" do
        @reservation.publishing_app = ''
        expect(@reservation).not_to be_valid
        expect(@reservation.errors[:publishing_app].size).to eq(1)
      end
    end
  end

  it "supports paths longer than 255 chars" do
    reservation = build(:reservation)
    reservation.path = "/" + 'x' * 300
    expect {
      reservation.save!
    }.not_to raise_error
  end

  describe "claimable_by?" do
    before :each do
      @reservation = build(:reservation)
    end

    it "returns true for a new record" do
      expect(@reservation.can_be_claimed_by?(@reservation.publishing_app)).to eq(true)
      expect(@reservation.can_be_claimed_by?("foo")).to eq(true)
    end

    context "for an existing record" do
      before :each do
        @reservation.save!
      end

      it "returns true if the publishing_app matches" do
        expect(@reservation.can_be_claimed_by?(@reservation.publishing_app)).to eq(true)
      end

      it "returns false if the publishign app is different" do
        expect(@reservation.can_be_claimed_by?("foo")).to eq(false)
      end
    end
  end

  describe "json representation" do
    before :each do
      @reservation = build(:reservation)
    end

    it "does not include the internal id" do
      expect(@reservation.as_json).not_to have_key("id")
    end

    it "includes details of any errors" do
      @reservation.publishing_app = ""
      @reservation.valid?

      json_hash = @reservation.as_json
      expect(json_hash).to have_key("errors")
      expect(json_hash["errors"]).to eq({"publishing_app" => ["can't be blank"]})
    end

    it "does not include the 'errors' key if there are no errors" do
      expect(@reservation.as_json).not_to have_key("errors")
    end
  end
end
