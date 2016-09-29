require 'dm_core'

module DmKnowledge
  class Engine < ::Rails::Engine
    isolate_namespace DmKnowledge

    config.to_prepare do
      require_dependency 'dm_knowledge/model_decorators'
    end

    config.generators do |g|
      g.test_framework      :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
