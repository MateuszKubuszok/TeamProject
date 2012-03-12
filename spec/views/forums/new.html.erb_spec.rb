require 'spec_helper'

describe "forums/new.html.erb" do
  before(:each) do
    assign(:forum, stub_model(Forum,
      :name => "MyString",
      :description => "MyString",
      :forum_id => 1,
      :private => false
    ).as_new_record)
  end

  it "renders new forum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => forums_path, :method => "post" do
      assert_select "input#forum_name", :name => "forum[name]"
      assert_select "input#forum_description", :name => "forum[description]"
      assert_select "input#forum_forum_id", :name => "forum[forum_id]"
      assert_select "input#forum_private", :name => "forum[private]"
    end
  end
end
