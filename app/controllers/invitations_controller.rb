class InvitationsController < ApplicationController
  admin_requirements              :manage_projects
  before_filter :require_user
  before_filter :require_access,  only: [ :new ]

  before_filter :load_invitation, only: [ :accept, :destroy ]

  # GET /invitations
  # GET /invitations.json
  def index
    @invitations = current_user.team_invitations

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invitations }
    end
  end

  # GET /invitations/to_project/project/user
  # GET /invitations/to_project/project/user.json
  def new_to_project
    user      = User.find_by_url    params[:user_id]
    project   = Project.find_by_url params[:project_id]

    respond_to do |format|
      if (current_user.projects-user.projects-user.possible_projects).include? project
        invitation = TeamInvitation.new({
          'user_id'     =>  user.id,
          'project_id'  =>  project.id
        })
        if invitation.save
          format.html { redirect_to :back, notice: "You have invited #{user.name} to project #{project.name}'!" }
          format.json { head :ok }
        else
          format.html { redirect_to :back, notice: "An error occurred. Try again later!" }
          format.json { head :unprocessable_entity }
        end
      else
        format.html { redirect_to :back, notice: "You cannot invite someone who is already invited to the project!" }
        format.json { head :unprocessable_entity }
      end
    end
  end

  # GET /invitations/1/accept
  # GET /invitations/1/accept.json
  def accept
    @invitation.accept

    respond_to do |format|
      format.html { redirect_to invitations_url, notice: "You accepted an invitation to project: #{@invitation.project.name}!" }
      format.json { head :ok }
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to invitations_url, notice: "You refused an invitation to project: #{@invitation.project.name}!" }
      format.json { head :ok }
    end
  end

  private

  # Pobiera zaproszenie.
  def load_invitation
    begin
      @invitation = TeamInvitation.find(params[:id])
      unless @invitation.user_id.equal?(current_user.id) || meet_requirements?(:manage_projects)
        respond_to do |format|
          format.html { redirect_to(homepage_path, :notice => "You cannot respond to other users' invitations!") }
          format.json { head :unauthorized }
        end
      end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to(homepage_path, :notice => "#{$!}") }
        format.json { head :not_found }
      end
    end
  end
end
