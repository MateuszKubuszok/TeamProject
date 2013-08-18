class TagsController < ApplicationController
  before_filter :load_tag, only: [ :show ]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Kaminari.paginate_array(ActsAsTaggableOn::Tag.all).page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @projects_tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render json: @projects }
    end
  end

  private

  def load_tag
    @projects = Kaminari.paginate_array(Project.tagged_with params[:id]).page params[:project_page]
    @threads = Kaminari.paginate_array(ForumThread.tagged_with params[:id]).page params[:forums_page]
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(tags_path, :notice => "#{$!}") }
      format.json { head :not_found }
    end
  end
end
