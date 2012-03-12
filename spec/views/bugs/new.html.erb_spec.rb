require 'spec_helper'

describe "bugs/new.html.erb" do
  before(:each) do
    assign(:bug, stub_model(Bug,
      :id => 1,
      :project_id => 1,
      :status_id => 1,
      :priority_id => 1,
      :short_description => "MyString",
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new bug form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bugs_path, :method => "post" do
      assert_select "input#bug_id", :name => "bug[id]"
      assert_select "input#bug_project_id", :name => "bug[project_id]"
      assert_select "input#bug_status_id", :name => "bug[status_id]"
      assert_select "input#bug_priority_id", :name => "bug[priority_id]"
      assert_select "input#bug_short_description", :name => "bug[short_description]"
      assert_select "textarea#bug_description", :name => "bug[description]"
    end
  end
end
