require 'spec_helper'

describe "responses/index.html.erb" do
  before(:each) do
    assign(:responses, [
      stub_model(Response,
        :forum_thread_id => 1,
        :title => "Title",
        :content => "MyText",
        :user_id => 1
      ),
      stub_model(Response,
        :forum_thread_id => 1,
        :title => "Title",
        :content => "MyText",
        :user_id => 1
      )
    ])
  end

  it "renders a list of responses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
