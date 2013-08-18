require 'spec_helper'

describe "forums/edit.html.erb" do
  before(:each) do
    @forum = assign(:forum, stub_model(Forum,
      :name => "MyString",
      :description => "MyString",
      :forum_id => 1,
      :private => false
    ))
  end

  it "renders the edit forum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => forums_path(@forum), :method => "post" do
      assert_select "input#forum_name", :name => "forum[name]"
      assert_select "input#forum_description", :name => "forum[description]"
      assert_select "input#forum_forum_id", :name => "forum[forum_id]"
      assert_select "input#forum_private", :name => "forum[private]"
    end
  end
end
