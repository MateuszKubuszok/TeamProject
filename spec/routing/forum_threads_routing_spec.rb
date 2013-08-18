require "spec_helper"

describe ForumThreadsController do
  describe "routing" do

    it "routes to #index" do
      get("/forum_threads").should route_to("forum_threads#index")
    end

    it "routes to #new" do
      get("/forum_threads/new").should route_to("forum_threads#new")
    end

    it "routes to #show" do
      get("/forum_threads/1").should route_to("forum_threads#show", :id => "1")
    end

    it "routes to #edit" do
      get("/forum_threads/1/edit").should route_to("forum_threads#edit", :id => "1")
    end

    it "routes to #create" do
      post("/forum_threads").should route_to("forum_threads#create")
    end

    it "routes to #update" do
      put("/forum_threads/1").should route_to("forum_threads#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/forum_threads/1").should route_to("forum_threads#destroy", :id => "1")
    end

  end
end
