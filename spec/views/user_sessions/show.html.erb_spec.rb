require 'spec_helper'

describe "user_sessions/show.html.erb" do
  before(:each) do
    @user_session = assign(:user_session, stub_model(UserSession,
      :name => "Name",
      :password => "Password"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Password/)
  end
end
