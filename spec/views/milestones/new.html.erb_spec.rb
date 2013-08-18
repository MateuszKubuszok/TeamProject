require 'spec_helper'

describe "milestones/new.html.erb" do
  before(:each) do
    assign(:milestone, stub_model(Milestone,
      :name => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new milestone form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => milestones_path, :method => "post" do
      assert_select "input#milestone_name", :name => "milestone[name]"
      assert_select "input#milestone_description", :name => "milestone[description]"
    end
  end
end
