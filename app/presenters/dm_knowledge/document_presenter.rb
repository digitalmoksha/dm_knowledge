class DmKnowledge::DocumentPresenter < BasePresenter

  presents :document

  #------------------------------------------------------------------------------
  def label_published
    document.is_published? ? h.colored_label('Published', :success) : h.colored_label('Draft')
  end

end