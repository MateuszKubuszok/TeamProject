require 'spec_helper'

describe "inner_invitations/show.html.erb" do
  before(:each) do
    @inner_invitation = assign(:inner_invitation, stub_model(TeamInvitation,
      :id => 1,
      :project_id => 1,
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
