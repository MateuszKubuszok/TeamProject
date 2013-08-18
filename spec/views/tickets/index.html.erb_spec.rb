require 'spec_helper'

describe "tickets/index.html.erb" do
  before(:each) do
    assign(:tickets, [
      stub_model(Ticket,
        :name => "Name",
        :description => "Description",
        :milestone => "",
        :user => ""
      ),
      stub_model(Ticket,
        :name => "Name",
        :description => "Description",
        :milestone => "",
        :user => ""
      )
    ])
  end

  it "renders a list of tickets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
