require 'spec_helper'

describe "projects/show.html.erb" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "Name",
      :url_name => "Url Name",
      :short_description => "Short Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Short Description/)
  end
end
