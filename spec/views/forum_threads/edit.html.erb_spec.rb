require 'spec_helper'

describe "forum_threads/edit.html.erb" do
  before(:each) do
    @forum_thread = assign(:forum_thread, stub_model(ForumThread,
      :forum_id => 1
    ))
  end

  it "renders the edit forum_thread form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => forum_threads_path(@forum_thread), :method => "post" do
      assert_select "input#forum_thread_forum_id", :name => "forum_thread[forum_id]"
    end
  end
end
