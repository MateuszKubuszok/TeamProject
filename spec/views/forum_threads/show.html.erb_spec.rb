require 'spec_helper'

describe "forum_threads/show.html.erb" do
  before(:each) do
    @forum_thread = assign(:forum_thread, stub_model(ForumThread,
      :forum_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
