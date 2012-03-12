require 'spec_helper'

describe "ForumThreads" do
  describe "GET /forum_threads" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get forum_threads_path
      response.status.should be(200)
    end
  end
end
