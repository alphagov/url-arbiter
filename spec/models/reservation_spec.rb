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
end
