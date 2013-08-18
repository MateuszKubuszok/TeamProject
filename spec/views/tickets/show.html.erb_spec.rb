require 'spec_helper'

describe "tickets/show.html.erb" do
  before(:each) do
    @ticket = assign(:ticket, stub_model(Ticket,
      :name => "Name",
      :description => "Description",
      :milestone => "",
      :user => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
