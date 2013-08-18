require 'spec_helper'

describe "forum_threads/new.html.erb" do
  before(:each) do
    assign(:forum_thread, stub_model(ForumThread,
      :forum_id => 1
    ).as_new_record)
  end

  it "renders new forum_thread form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => forum_threads_path, :method => "post" do
      assert_select "input#forum_thread_forum_id", :name => "forum_thread[forum_id]"
    end
  end
end
