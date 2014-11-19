module DmKnowledge
  module PermittedParams

    #------------------------------------------------------------------------------
    def document_params
      params.require(:document).permit! if can? :manage_knowledge, :all
    end

  end
end