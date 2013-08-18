require 'spec_helper'

describe "inner_invitations/index.html.erb" do
  before(:each) do
    assign(:invitations, [
      stub_model(TeamInvitation,
        :id => 1,
        :project_id => 1,
        :user_id => 1
      ),
      stub_model(TeamInvitation,
        :id => 1,
        :project_id => 1,
        :user_id => 1
      )
    ])
  end

  it "renders a list of inner_invitations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
