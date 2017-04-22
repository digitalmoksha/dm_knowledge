class DmKnowledge::Admin::DocumentMediaFilesController < DmKnowledge::Admin::AdminController
  include DmKnowledge::PermittedParams

  before_action   :document_lookup

  #------------------------------------------------------------------------------
  def new
    @media_file = DmKnowledge::DocumentMediaFile.new
  end
  
  #------------------------------------------------------------------------------
  def edit
    @media_file = DmKnowledge::DocumentMediaFile.find(params[:id])
  end
  
  #------------------------------------------------------------------------------
  def create
    @media_file   = DmKnowledge::DocumentMediaFile.new(media_file_params)  # for collecting all error msgs
    if params[:media_list]
      params[:media_list].each do |file|
        media_file          = DmKnowledge::DocumentMediaFile.new(media_file_params)
        media_file.media    = file
        media_file.document = @document
        if !media_file.save
          media_file.errors.each { |attribute, error| @media_file.errors.add(attribute, error) }
        end
      end
    else
      @media_file.errors[:base] << 'Please select files to upload'
    end
    if @media_file.errors.empty?
      redirect_to admin_document_url(@document), notice: 'Media successfully uploaded'
    else
      render action: :new
    end
  end
  
  #------------------------------------------------------------------------------
  def update
    @media_file = DmKnowledge::DocumentMediaFile.find(params[:id])
    if @media_file.update_attributes(media_file_params)
      redirect_to admin_document_url(@document), notice: 'Media successfully updated'
    else
      render action: :edit
    end
  end
  
  #------------------------------------------------------------------------------
  def destroy
    @media_file = MediaFile.find(params[:id])
    @media_file.destroy
    redirect_to admin_media_files_url
  end
  
private

  #------------------------------------------------------------------------------
  def document_lookup
    @document = DmKnowledge::Document.friendly.find(params[:document_id])
  end

  # Set some values for the template based on the controller
  #------------------------------------------------------------------------------
  def template_setup
  end

end
