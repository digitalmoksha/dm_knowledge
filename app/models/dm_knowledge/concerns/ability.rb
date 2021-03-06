# Wrap knowledge specific CanCan rules.  Should be included in the main app's
# Ability class.
# NOTE:  When checking abilities, don't check for Class level abilities,
# unless you don't care about the instance level.  For example, don't
# use both styles
#   can? :moderate, Forum
#   can? :moderate, @forum
# In this case, if you need to check the class level, then use specific
#    current_user.has_role? :moderator, Forum
#------------------------------------------------------------------------------

module DmKnowledge
  module Concerns
    module Ability
      def dm_knowledge_abilities(user)
        if user
          #--- Admin
          if user.has_role?(:content_manager)
            can :manage_content, :all
            can :access_admin, :all
          end

          #--- Blog
          # can(:read, CmsBlog)   { |blog| blog.can_be_read_by?(user) }
          # can(:reply, CmsBlog)  { |blog| blog.can_be_replied_by?(user) }
          # can :moderate, CmsBlog, :id => CmsBlog.published.with_role(:moderator, user).map(&:id)
          
          can(:read, DmKnowledge::Document)   { |document| document.is_published? || user.has_role?(:reviewer)}
        else
          #--- can only read/see public blogs when not logged in
          # can(:read, CmsBlog)   { |blog| blog.can_be_read_by?(user) }
          # can(:read, CmsPost)   { |post| post.is_published? }
        end
      end

      ::Ability.register_abilities(:dm_knowledge_abilities)

    end
  end
end

#------------------------------------------------------------------------------
# The abilities get basically compiled.  So if you use
#
#    can :moderate, Forum, :id => Forum.with_role(:moderator, user).map(&:id)
#
# this will execute the Forum.with_role query once during Ability.new.  However
#
#    can :moderate, Forum do |forum|
#      user.has_role? :moderator, forum
#    end
#
# this will execute the has_role? block on each call to can?
