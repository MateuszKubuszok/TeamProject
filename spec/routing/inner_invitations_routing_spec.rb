require "spec_helper"

describe InnerInvitationsController do
  describe "routing" do

    it "routes to #index" do
      get("/inner_invitations").should route_to("inner_invitations#index")
    end

    it "routes to #new" do
      get("/inner_invitations/new").should route_to("inner_invitations#new")
    end

    it "routes to #show" do
      get("/inner_invitations/1").should route_to("inner_invitations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/inner_invitations/1/edit").should route_to("inner_invitations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/inner_invitations").should route_to("inner_invitations#create")
    end

    it "routes to #update" do
      put("/inner_invitations/1").should route_to("inner_invitations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/inner_invitations/1").should route_to("inner_invitations#destroy", :id => "1")
    end

  end
end
