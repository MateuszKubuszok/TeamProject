require 'spec_helper'

describe "forum_threads/index.html.erb" do
  before(:each) do
    assign(:forum_threads, [
      stub_model(ForumThread,
        :forum_id => 1
      ),
      stub_model(ForumThread,
        :forum_id => 1
      )
    ])
  end

  it "renders a list of forum_threads" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
