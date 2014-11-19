DmKnowledge::Engine.routes.draw do
  scope ":locale" do
    namespace :admin do
      resources :documents do
        member do
          patch    :add_tags,          controller: 'documents', action: :add_tags
        end
      end
    end
  end
end
