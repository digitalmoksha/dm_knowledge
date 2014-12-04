module DmKnowledge
  module PermittedParams

    #------------------------------------------------------------------------------
    def document_params
      params.require(:document).permit! if can? :manage_knowledge, :all
    end

    #------------------------------------------------------------------------------
    def media_file_params
      params.require(:document_media_file).permit! if can? :manage_knowledge, :all
    end

  end
end