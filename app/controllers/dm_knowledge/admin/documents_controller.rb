class DmKnowledge::Admin::DocumentsController < DmKnowledge::Admin::AdminController
  include DmKnowledge::PermittedParams
  include DmKnowledge::SkmlHelper
  
  before_filter   :document_lookup, :except =>  [:index, :new, :create, :tag_contents]
  
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
    @taglist  = @document.replace_context_tags(@srcid, params[:document][:tag_list]).to_json
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
  
  #------------------------------------------------------------------------------
  def tag_contents
    tagname       = params[:tag]
    taggings      = DmKnowledge::Document.sources_tagged_with(tagname)
    @document_list = DmKnowledge::Document.tagged_document_list(taggings)
  end
  
private

  #------------------------------------------------------------------------------
  def document_lookup
    @document = DmKnowledge::Document.friendly.find(params[:id])
  end

end