class DashboardController < ApplicationController
#  include AuthenticatedSystem
  
  def index
    redirect_to :action => 'main_dashboard'
  end

  def main_dashboard
    logger.debug("DEBUG: #{current_user.inspect}")
    if logged_in?
      @image_sets = current_user.image_sets #ImageSet.find(:all)  
    end
    @collections = Collection.find(:all)    
    @users = User.find(:all)

    @offset = params[:offset] || 0
    @recent_versions = 
      PageVersion.find(:all,
                       :limit => 20,
                       :offset => @offset,
                       :include => [:user, :page],
                       :order => 'page_versions.created_on desc')

    sql = 
      'select count(distinct session_id) count ' +
      'from interactions '+
      'where created_on > date_sub(now(), interval 20 minute) ' +
      "and browser not like '%Googlebot%' " +
      "and browser not like '%Yahoo! Slurp%' " 
    
    @user_count = 
      Interaction.connection.select_value(sql)
  end

end

