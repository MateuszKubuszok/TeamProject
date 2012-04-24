class ForumsController < ForumElementController
  admin_requirements                      :manage_forums
  before_filter   :require_admin,         only: [ :new, :edit, :create, :update, :destroy ]
  before_filter   :load_forum,            only: [ :show, :edit, :update, :destroy ]
  before_filter   :load_possible_forums,  only: [ :new, :create, :edit, :update ]

  # GET /forums
  # GET /forums.json
  def index
    @forums = Forum.where(forum_id: nil)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @forums }
    end
  end

  # GET /forums/1
  # GET /forums/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @forum }
    end
  end

  # GET /forums/new
  # GET /forums/new.json
  def new
    @forum = Forum.new
    @forum.forum_id = params[:forum_id] if params[:forum_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forum }
    end
  end

  # GET /forums/1/edit
  def edit
  end

  # POST /forums
  # POST /forums.json
  def create
    @forum = Forum.new(params[:forum])

    respond_to do |format|
      if @forum.save
        format.html { redirect_to @forum, notice: 'Forum was successfully created.' }
        format.json { render json: @forum, status: :created, location: @forum }
      else
        format.html { render action: "new" }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forums/1
  # PUT /forums/1.json
  def update
    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        format.html { redirect_to @forum, notice: 'Forum was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.json
  def destroy
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to forums_url }
      format.json { head :ok }
    end
  end

  private

  # Pobiera forum.
  def load_forum
    @forum = Forum.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(homepage_path, :notice => "#{$!}") }
      format.json { head :not_found }
    end
  end

  # Pobiera możliwe fora.
  def load_possible_forums
    @possible_forums = [ ['none', nil] ]
    if @forum
      @forum.possible_parents.each { |forum| @possible_forums << [forum.name, forum.id] }
    else
      Forum.all.each { |forum| @possible_forums << [forum.name, forum.id] }
    end
  end
end
