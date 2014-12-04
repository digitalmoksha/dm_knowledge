# For uploading files into the document media library.  
# Files are stored in the theme's 'protected_assets' folder.
#
# make sure ghostscript is installed for PDF thumbnailing
# on OSX, `brew install ghostscript`
#------------------------------------------------------------------------------
class DmKnowledge::DocumentMediaUploader < CarrierWave::Uploader::Base
  include DmCore::AccountHelper

  # Include RMagick or MiniMagick support:
  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  process :set_content_type

  # paritioning done like attachment_fu
  #------------------------------------------------------------------------------
  def store_dir
    partition_dir = ("%08d" % model.id).scan(/\d{4}/).join("/")
    "#{account_protected_assets(false)}/document_media/#{partition_dir}"
  end

  #------------------------------------------------------------------------------
  def cache_dir
    Rails.root + '/tmp/cache'
  end
  
  # We basically want the width to be the max, allowing the height to grow
  #------------------------------------------------------------------------------
  def resize_to_width(width)
    manipulate! do |img|
      img.resize "#{width}>"
      img = yield(img) if block_given?
      img
    end
  end

   # If a pdf, convert to jpg and size, maintain aspect ration and pad to square
   # If an image, resize it to a cropped square
   #------------------------------------------------------------------------------
   def thumb_image_pdf(width, height)
     if pdf?(self)
       self.convert(:jpg)
       self.resize_and_pad(width, height)
     else
       self.resize_to_fill(width, height)
     end
   end
   
   # Convert to png if a pdf, then size to a specfic width
   #------------------------------------------------------------------------------
   def size_image_pdf(width)
     self.convert(:jpg) if pdf?(self)
     self.resize_to_width(width)
   end
   
  # Create different versions of image files
  #------------------------------------------------------------------------------
  version :lg, :if => :thumbnable? do
    process :size_image_pdf => [900]
    def full_filename (for_file = model.file.file)
      model.pdf? ? (super.chomp(File.extname(super)) + '.jpg') : super
    end
  end

  version :md, :if => :thumbnable?, :from_version => :lg do
    process :size_image_pdf => [600]
    def full_filename (for_file = model.file.file)
      model.pdf? ? (super.chomp(File.extname(super)) + '.jpg') : super
    end
  end

  version :sm, :if => :thumbnable?, :from_version => :lg do
    process :size_image_pdf => [300]
    def full_filename (for_file = model.file.file)
      model.pdf? ? (super.chomp(File.extname(super)) + '.jpg') : super
    end
  end

  version :thumb, :if => :thumbnable?, :from_version => :lg do
    process thumb_image_pdf: [200, 200]
    def full_filename (for_file = model.file.file)
      model.pdf? ? (super.chomp(File.extname(super)) + '.jpg') : super
    end
  end


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  #------------------------------------------------------------------------------
  def extension_white_list
    %w(jpg jpeg gif png mp3 mp4 m4v wav pdf md markdown txt rtf doc docx)
  end

protected

  #------------------------------------------------------------------------------
  def thumbnable?(new_file)
    image?(new_file) || pdf?(new_file)
  end

  #------------------------------------------------------------------------------
  def image?(new_file)
    new_file.content_type.start_with? 'image'
  end

  #------------------------------------------------------------------------------
  def pdf?(new_file)
    new_file.content_type.end_with? 'pdf'
  end
  
end
