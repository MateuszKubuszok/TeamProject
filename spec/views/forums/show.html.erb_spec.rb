require 'spec_helper'

describe "forums/show.html.erb" do
  before(:each) do
    @forum = assign(:forum, stub_model(Forum,
      :name => "Name",
      :description => "Description",
      :forum_id => 1,
      :private => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
