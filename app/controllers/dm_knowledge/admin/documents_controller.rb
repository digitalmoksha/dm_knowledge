class DmKnowledge::Admin::DocumentsController < DmKnowledge::Admin::AdminController
  include DmKnowledge::PermittedParams
  include DmKnowledge::SkmlHelper
  
  before_filter   :document_lookup, :except =>  [:index, :new, :create]
  
  #------------------------------------------------------------------------------
  def index
    @documents = DmKnowledge::Document.all
  end

  #------------------------------------------------------------------------------
  def show
  end

  #------------------------------------------------------------------------------
  def new
    @document = DmKnowledge::Document.new
  end

  #------------------------------------------------------------------------------
  def edit
  end

  #------------------------------------------------------------------------------
  def create
    @document = DmKnowledge::Document.new(document_params)
    if @document.save
      redirect_to admin_document_path(@document.id), notice: 'Document was successfully created.'
    else
      render action: :new
    end
  end

  #------------------------------------------------------------------------------
  def update
    params[:content] = skml_set_srcids(params[:document][:content])
    if @document.update_attributes(document_params)
      redirect_to admin_document_path(@document.id), notice: 'Document was successfully updated.'
    else
      render action: :edit
    end
  end

  #------------------------------------------------------------------------------
  def add_tags
    @srcid    = params[:document][:srcid]
    @tagid    = DmKnowledge::Document.tagcontext_from_srcid(@srcid)
    @document.set_tag_list_on(@tagid, params[:document][:tag_list])
    @document.save!
    @taglist  = @document.tag_list_on(@tagid).to_json
    respond_to do |format| 
      format.html { redirect_to admin_document_url(@document.id), notice: 'Document was successfully updated.' }
      format.js { render action: :add_tags }
    end
  end
  
  #------------------------------------------------------------------------------
  def destroy
    @document.destroy
    redirect_to admin_documents_url, notice: 'Document was successfully deleted.'
  end
  
private

  #------------------------------------------------------------------------------
  def document_lookup
    @document = DmKnowledge::Document.find(params[:id])
  end

end