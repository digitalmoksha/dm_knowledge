#------------------------------------------------------------------------------
class DmKnowledge::DocumentMediaFile < ActiveRecord::Base

  self.table_name = 'knw_document_media_files'
  
  translates              :title, :description, fallbacks_for_empty_translations: true
  globalize_accessors     locales: DmCore::Language.language_array

  belongs_to              :document
  default_scope           { where(account_id: Account.current.id) }
  
  #--- Using Carrierwave
  mount_uploader          :media, DocumentMediaUploader
  before_save             :prepare_attributes
  
  #------------------------------------------------------------------------------
  def short_location(version = nil)
    version ? self.media.versions[version].file.filename : self.media.file.filename
  end
  
  #------------------------------------------------------------------------------
  def image?
    self.media_content_type.start_with? 'image'
  end

  #------------------------------------------------------------------------------
  def pdf?
    self.media_content_type.end_with? 'pdf'
  end
  
private

  # Save the media metadata, and add the 'folder' as a tag
  #------------------------------------------------------------------------------
  def prepare_attributes
    if media.present? && media_changed?
      self.media_content_type = media.file.content_type
      self.media_file_size    = media.file.size
    end
  end
  

end
