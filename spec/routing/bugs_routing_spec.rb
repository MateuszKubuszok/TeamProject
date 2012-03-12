require "spec_helper"

describe BugsController do
  describe "routing" do

    it "routes to #index" do
      get("/bugs").should route_to("bugs#index")
    end

    it "routes to #new" do
      get("/bugs/new").should route_to("bugs#new")
    end

    it "routes to #show" do
      get("/bugs/1").should route_to("bugs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bugs/1/edit").should route_to("bugs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bugs").should route_to("bugs#create")
    end

    it "routes to #update" do
      put("/bugs/1").should route_to("bugs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bugs/1").should route_to("bugs#destroy", :id => "1")
    end

  end
end
