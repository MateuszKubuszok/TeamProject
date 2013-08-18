require 'spec_helper'

describe "bugs/index.html.erb" do
  before(:each) do
    assign(:bugs, [
      stub_model(Bug,
        :id => 1,
        :project_id => 1,
        :status_id => 1,
        :priority_id => 1,
        :short_description => "Short Description",
        :description => "MyText"
      ),
      stub_model(Bug,
        :id => 1,
        :project_id => 1,
        :status_id => 1,
        :priority_id => 1,
        :short_description => "Short Description",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of bugs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Short Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
