require 'spec_helper'

describe "bugs/edit.html.erb" do
  before(:each) do
    @bug = assign(:bug, stub_model(Bug,
      :id => 1,
      :project_id => 1,
      :status_id => 1,
      :priority_id => 1,
      :short_description => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit bug form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bugs_path(@bug), :method => "post" do
      assert_select "input#bug_id", :name => "bug[id]"
      assert_select "input#bug_project_id", :name => "bug[project_id]"
      assert_select "input#bug_status_id", :name => "bug[status_id]"
      assert_select "input#bug_priority_id", :name => "bug[priority_id]"
      assert_select "input#bug_short_description", :name => "bug[short_description]"
      assert_select "textarea#bug_description", :name => "bug[description]"
    end
  end
end
