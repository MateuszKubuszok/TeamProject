require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe BugsController do

  # This should return the minimal set of attributes required to create a valid
  # Bug. As you add validations to Bug, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all bugs as @bugs" do
      bug = Bug.create! valid_attributes
      get :index
      assigns(:bugs).should eq([bug])
    end
  end

  describe "GET show" do
    it "assigns the requested bug as @bug" do
      bug = Bug.create! valid_attributes
      get :show, :id => bug.id.to_s
      assigns(:bug).should eq(bug)
    end
  end

  describe "GET new" do
    it "assigns a new bug as @bug" do
      get :new
      assigns(:bug).should be_a_new(Bug)
    end
  end

  describe "GET edit" do
    it "assigns the requested bug as @bug" do
      bug = Bug.create! valid_attributes
      get :edit, :id => bug.id.to_s
      assigns(:bug).should eq(bug)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Bug" do
        expect {
          post :create, :bug => valid_attributes
        }.to change(Bug, :count).by(1)
      end

      it "assigns a newly created bug as @bug" do
        post :create, :bug => valid_attributes
        assigns(:bug).should be_a(Bug)
        assigns(:bug).should be_persisted
      end

      it "redirects to the created bug" do
        post :create, :bug => valid_attributes
        response.should redirect_to(Bug.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bug as @bug" do
        # Trigger the behavior that occurs when invalid params are submitted
        Bug.any_instance.stub(:save).and_return(false)
        post :create, :bug => {}
        assigns(:bug).should be_a_new(Bug)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Bug.any_instance.stub(:save).and_return(false)
        post :create, :bug => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bug" do
        bug = Bug.create! valid_attributes
        # Assuming there are no other bugs in the database, this
        # specifies that the Bug created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Bug.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => bug.id, :bug => {'these' => 'params'}
      end

      it "assigns the requested bug as @bug" do
        bug = Bug.create! valid_attributes
        put :update, :id => bug.id, :bug => valid_attributes
        assigns(:bug).should eq(bug)
      end

      it "redirects to the bug" do
        bug = Bug.create! valid_attributes
        put :update, :id => bug.id, :bug => valid_attributes
        response.should redirect_to(bug)
      end
    end

    describe "with invalid params" do
      it "assigns the bug as @bug" do
        bug = Bug.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Bug.any_instance.stub(:save).and_return(false)
        put :update, :id => bug.id.to_s, :bug => {}
        assigns(:bug).should eq(bug)
      end

      it "re-renders the 'edit' template" do
        bug = Bug.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Bug.any_instance.stub(:save).and_return(false)
        put :update, :id => bug.id.to_s, :bug => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bug" do
      bug = Bug.create! valid_attributes
      expect {
        delete :destroy, :id => bug.id.to_s
      }.to change(Bug, :count).by(-1)
    end

    it "redirects to the bugs list" do
      bug = Bug.create! valid_attributes
      delete :destroy, :id => bug.id.to_s
      response.should redirect_to(bugs_url)
    end
  end

end
