require 'spec_helper'

describe "user_sessions/index.html.erb" do
  before(:each) do
    assign(:user_sessions, [
      stub_model(UserSession,
        :name => "Name",
        :password => "Password"
      ),
      stub_model(UserSession,
        :name => "Name",
        :password => "Password"
      )
    ])
  end

  it "renders a list of user_sessions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Password".to_s, :count => 2
  end
end
