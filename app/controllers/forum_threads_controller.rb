class ForumThreadsController < ForumElementController
  admin_requirements              :manage_forums
  before_filter :require_user,    only: [ :new, :create ]
  before_filter :require_access,  only: [ :edit, :update ]
  before_filter :require_admin,   only: [ :destroy ]

  before_filter :load_forum
  before_filter :load_thread, only: [ :show, :edit, :update, :destroy ]

  # GET /forum_threads
  # GET /forum_threads.json
  def index
    @forum_threads = @forum.forum_threads

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @forum_threads }
    end
  end

  # GET /forum_threads/1
  # GET /forum_threads/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @forum_thread }
    end
  end

  # GET /forum_threads/new
  # GET /forum_threads/new.json
  def new
    @forum_thread = ForumThread.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forum_thread }
    end
  end

  # GET /forum_threads/1/edit
  def edit
  end

  # POST /forum_threads
  # POST /forum_threads.json
  def create
    @forum_thread = ForumThread.new(params[:forum_thread])
    @forum_thread.forum_id = @forum.id
    @forum_thread.user_id = current_user.id

    respond_to do |format|
      if @forum_thread.save
        format.html { redirect_to [@forum, @forum_thread], notice: 'Forum thread was successfully created.' }
        format.json { render json: @forum_thread, status: :created, location: [@forum, @forum_thread] }
      else
        format.html { render action: "new" }
        format.json { render json: @forum_thread.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forum_threads/1
  # PUT /forum_threads/1.json
  def update
    @forum_thread.edited_by = current_user.id

    respond_to do |format|
      if @forum_thread.update_attributes(params[:forum_thread])
        format.html { redirect_to [@forum, @forum_thread], notice: 'Forum thread was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @forum_thread.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_threads/1
  # DELETE /forum_threads/1.json
  def destroy
    @forum_thread.destroy

    respond_to do |format|
      format.html { redirect_to @forum }
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
    @forum_thread = ForumThread.find_by_id_and_forum_id(params[:id], params[:forum_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(forum_path(@forum.id), :notice => "#{$!}") }
      format.json { head :not_found }
    end
  end
end
