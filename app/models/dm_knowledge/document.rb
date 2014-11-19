class DmKnowledge::Document < ActiveRecord::Base
  include DmCore::Concerns::PublicPrivate

  self.table_name = 'knw_documents'

  # --- FriendlyId
  extend FriendlyId
  include DmCore::Concerns::FriendlyId

  acts_as_taggable

  belongs_to              :account
  default_scope           { where(account_id: Account.current.id) }

  validates_presence_of   :title, :original_date, :content

  # Generate an array of unique tags used in all documents, sorted case insensitively
  #------------------------------------------------------------------------------
  def self.document_tag_list
    ActsAsTaggableOn::Tag.joins(:taggings).where('taggings.taggable_type' => 'DmKnowledge::Document').map {|x| x.name}.uniq.sort {|x,y| x.casecmp(y) }
  end
  
  # tags are attached to a source paragraph by using 'contexts'.  A tag context
  # must begin with an alphanumeric character
  #------------------------------------------------------------------------------
  def self.tagcontext_from_srcid(srcid)
    's_' + srcid.to_s.gsub('.', '_')
  end

  #------------------------------------------------------------------------------
  def model_slug
    (self.original_date ? self.original_date.to_date.to_s : Time.now.to_date.to_s) + '-' + (self.title ? self.title : '')
  end

  #------------------------------------------------------------------------------
  def is_published?
    published
  end
  
end