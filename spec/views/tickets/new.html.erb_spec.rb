require 'spec_helper'

describe "tickets/new.html.erb" do
  before(:each) do
    assign(:ticket, stub_model(Ticket,
      :name => "MyString",
      :description => "MyString",
      :milestone => "",
      :user => ""
    ).as_new_record)
  end

  it "renders new ticket form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tickets_path, :method => "post" do
      assert_select "input#ticket_name", :name => "ticket[name]"
      assert_select "input#ticket_description", :name => "ticket[description]"
      assert_select "input#ticket_milestone", :name => "ticket[milestone]"
      assert_select "input#ticket_user", :name => "ticket[user]"
    end
  end
end
