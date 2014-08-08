require 'rails_helper'

describe "routing of reservation requests", :type => :routing do
  context "PUT route" do
    it "should route to the controller passing on the reserved_path" do
      expect(:put => "/paths/foo/bar").to route_to({
        :controller => "reservations",
        :action => "update",
        :reserved_path => "/foo/bar",
      })
    end

    it "should not match a reserved_path without a leading /" do
      expect(:put => "/pathsfoo").not_to be_routable
    end
  end
end

