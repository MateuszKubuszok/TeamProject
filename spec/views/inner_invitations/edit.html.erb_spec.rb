require 'spec_helper'

describe "inner_invitations/edit.html.erb" do
  before(:each) do
    @inner_invitation = assign(:inner_invitation, stub_model(TeamInvitation,
      :id => 1,
      :project_id => 1,
      :user_id => 1
    ))
  end

  it "renders the edit inner_invitation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => inner_invitations_path(@inner_invitation), :method => "post" do
      assert_select "input#inner_invitation_id", :name => "inner_invitation[id]"
      assert_select "input#inner_invitation_project_id", :name => "inner_invitation[project_id]"
      assert_select "input#inner_invitation_user_id", :name => "inner_invitation[user_id]"
    end
  end
end
