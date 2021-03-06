$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dm_knowledge/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dm_knowledge"
  s.version     = DmKnowledge::VERSION
  s.authors     = ["Brett Walker"]
  s.email       = ["github@digitalmoksha.com"]
  s.homepage    = ""
  s.summary     = "Knowledge Document Database"
  s.description = "Knowledge Document Database"
  s.license     = "TBD"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails', '> 4.2', '< 5.1'
  
  #--- make sure the following gems are included in your app's Gemfile
  # gem 'dm_core', :git => 'git://github.com/digitalmoksha/dm_core.git'
end
