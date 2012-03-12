require 'spec_helper'

describe "responses/edit.html.erb" do
  before(:each) do
    @response = assign(:response, stub_model(Response,
      :forum_thread_id => 1,
      :title => "MyString",
      :content => "MyText",
      :user_id => 1
    ))
  end

  it "renders the edit response form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => responses_path(@response), :method => "post" do
      assert_select "input#response_forum_thread_id", :name => "response[forum_thread_id]"
      assert_select "input#response_title", :name => "response[title]"
      assert_select "textarea#response_content", :name => "response[content]"
      assert_select "input#response_user_id", :name => "response[user_id]"
    end
  end
end
