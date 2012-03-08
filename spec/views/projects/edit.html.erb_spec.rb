require 'spec_helper'

describe "projects/edit.html.erb" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "MyString",
      :url_name => "MyString",
      :short_description => "MyString"
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path(@project), :method => "post" do
      assert_select "input#project_name", :name => "project[name]"
      assert_select "input#project_url_name", :name => "project[url_name]"
      assert_select "input#project_short_description", :name => "project[short_description]"
    end
  end
end
