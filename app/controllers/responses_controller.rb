class ResponsesController < ApplicationController
  admin_requirements :manage_forums
  before_filter :require_user,  only: [ :new, :create ]
  before_filter :require_admin, only: [ :edit, :update, :destroy ]

  before_filter :load_forum
  before_filter :load_thread
  before_filter :load_response, only: [ :show, :edit, :update, :destroy ]

  # GET /forums/1/forum_threads/1/responses
  # GET /forums/1/forum_threads/1/responses.json
  def index
    @responses = @forum_thread.responses.order('created_at ASC').page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @responses }
    end
  end

  # GET /forums/1/forum_threads/1/responses/1
  # GET /forums/1/forum_threads/1/responses/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @response }
    end
  end

  # GET /forums/1/forum_threads/1/responses/new
  # GET /forums/1/forum_threads/1/responses/new.json
  def new
    @response = Response.new
    @response.title = "Re: "+@forum_thread.title

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @response }
    end
  end

  # GET /forums/1/forum_threads/1/responses/1/edit
  def edit
  end

  # POST /forums/1/forum_threads/1/responses
  # POST /forums/1/forum_threads/1/responses.json
  def create
    @response = Response.new(params[:response])
    @response.forum_thread_id = @forum_thread.id
    @response.user_id = current_user.id

    respond_to do |format|
      if @response.save
        format.html { redirect_to [@forum, @forum_thread, @response], notice: 'Response was successfully created.' }
        format.json { render json: @response, status: :created, location: [@forum, @forum_thread, @response] }
      else
        format.html { render action: "new" }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forums/1/forum_threads/1/responses/1
  # PUT /forums/1/forum_threads/1/responses/1.json
  def update
    @response.edited_by = current_user.id

    respond_to do |format|
      if @response.update_attributes(params[:response])
        format.html { redirect_to [@forum, @forum_thread, @response], notice: 'Response was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1/forum_threads/1/responses/1
  # DELETE /forums/1/forum_threads/1/responses/1.json
  def destroy
    @response.destroy

    respond_to do |format|
      format.html { redirect_to [@forum, @forum_thread] }
      format.json { head :ok }
    end
  end

  private

  # Pobiera forum.
  def load_forum
    @forum = Forum.find(params[:forum_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(forums_path, :notice => "#{$!}") }
      format.json { head :not_found }
    end
  end

  # Pobiera wątek.
  def load_thread
    @forum_thread = ForumThread.find_by_id_and_forum_id(params[:forum_thread_id], params[:forum_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(forum_path(@forum.id), :notice => "#{$!}") }
      format.json { head :not_found }
    end
  end

  def load_response
    @response = Response.find_by_id_and_forum_thread_id(params[:id], params[:forum_thread_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(forum_forum_thread_path(@forum.id, @forum_thread.id), :notice => "#{$!}") }
      format.json { head :not_found }
    end
  end
end
