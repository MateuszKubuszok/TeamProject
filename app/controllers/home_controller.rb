class HomeController < ApplicationController
  def index
  end

  def faq
  end

  def about
  end

  def sitemap
    date = Time.new(1970,1,1).to_datetime

    @projects = Project.where(private: false).order("updated_at DESC").limit(50)
    @projects.each { |project| date = date > project.last_change ? date : project.last_change }

    @forums = Forum.where(forum_id: nil).order("updated_at DESC").limit(50)
    @forums.each { |forum| date > forum.last_thread.updated_at ? date : forum.last_thread.updated_at }

    headers["Content-Type"] = "text/xml"
    # set last modified header to the date of the latest entry.
    headers["Last-Modified"] = date.httpdate
    respond_to do |format|
      format.xml
    end
  end

  def widescreen_switch
    widescreen_layout_switch
    redirect_to request.referer
  end
end
