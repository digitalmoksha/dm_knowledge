class DmKnowledge::Document < ActiveRecord::Base
  include DmCore::Concerns::PublicPrivate

  self.table_name = 'knw_documents'

  # --- FriendlyId
  extend FriendlyId
  include DmCore::Concerns::FriendlyId

  has_many                :media_files, class_name: DmKnowledge::DocumentMediaFile, dependent: :destroy
  acts_as_taggable

  belongs_to              :account
  default_scope           { where(account_id: Account.current.id) }

  validates_presence_of   :title, :original_date, :content

  #------------------------------------------------------------------------------
  def model_slug
    (self.original_date ? self.original_date.to_date.to_s : Time.now.to_date.to_s) + '-' + (self.title ? self.title : '')
  end

  #------------------------------------------------------------------------------
  def is_published?
    published
  end
  
  # Given a list of tags, replace the tags currently at the srcid
  #------------------------------------------------------------------------------
  def replace_context_tags(srcid, tag_list)
    tagid = DmKnowledge::Document.tagcontext_from_srcid(srcid)
    set_tag_list_on(tagid, tag_list)
    save!
    return tag_list_on(tagid)
  end

  # Generate an array of unique tags used in all documents, sorted case insensitively
  #------------------------------------------------------------------------------
  def self.all_tags_list
    ActsAsTaggableOn::Tag.joins(:taggings).where('taggings.taggable_type' => 'DmKnowledge::Document').map {|x| x.name}.uniq.sort {|x,y| x.casecmp(y) }
  end
  
  # tags are attached to a source paragraph by using 'contexts'.  A tag context
  # must begin with an alphanumeric character
  #------------------------------------------------------------------------------
  def self.tagcontext_from_srcid(srcid)
    raise ArgumentError.new("srcid must be a string") unless srcid.is_a? String
    's_' + srcid.to_s.gsub('.', '_')
  end

  #------------------------------------------------------------------------------
  def self.srcid_from_tagcontext(srcid)
    srcid.start_with?('s_') ? srcid.sub('s_', '').gsub('_', '.') : nil
  end

  # return an array of taggings matching the tag name.  taggings include the
  # context, which gives us the source within a specific document
  #------------------------------------------------------------------------------
  def self.sources_tagged_with(tagname)
    tag = ActsAsTaggableOn::Tag.find_by_name(tagname)
    tag ? tag.taggings.where(taggable_type: self.to_s) : []
  end
  
  # Given an array of taggings that match a specific tag, return an array
  # [
  #   {document: found_document1, document_tagged: true, tagged_srcids: ['1.2', '1.4']},
  #   {document: found_document2, document_tagged: false, tagged_srcids: ['1.34', '1.35']}
  # ]
  #------------------------------------------------------------------------------
  def self.tagged_document_list(taggings)
    document_list = []
    taggings.group_by {|x| x.taggable_id}.each do |key, value|
      collection  = {document: value.first.taggable, document_tagged: false, tagged_srcids: []}
      value.each do |tagging|
        if tagging.context == 'tags'
          collection[:document_tagged] = true
        else
          collection[:tagged_srcids] << self.srcid_from_tagcontext(tagging.context)
        end
      end
      collection[:tagged_srcids].sort_by! {|s| s.split('.').map(&:to_i) }
      document_list << collection
    end
    document_list
  end
end