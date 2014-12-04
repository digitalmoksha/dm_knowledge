DmKnowledge::Engine.routes.draw do
  scope ":locale" do
    namespace :admin do
      resources :documents do
        member do
          patch    :add_tags,           controller: :documents, action: :add_tags
        end
        resources :document_media_files
      end
      get      'tag_contents/:tag',           controller: :documents, action: :tag_contents, as: :tag_contents
    end
  end
end
