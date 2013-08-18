require 'spec_helper'

describe "milestones/edit.html.erb" do
  before(:each) do
    @milestone = assign(:milestone, stub_model(Milestone,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit milestone form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => milestones_path(@milestone), :method => "post" do
      assert_select "input#milestone_name", :name => "milestone[name]"
      assert_select "input#milestone_description", :name => "milestone[description]"
    end
  end
end
