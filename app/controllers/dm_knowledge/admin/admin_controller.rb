class DmKnowledge::Admin::AdminController < DmCore::Admin::AdminController
  before_filter   :authorize_access
  helper DmKnowledge::SkmlHelper
  
protected

  #------------------------------------------------------------------------------
  def authorize_access
    unless can?(:manage_knowledge, :all)
      flash[:alert] = "Unauthorized Access!"
      redirect_to current_account.index_path 
    end
  end

end