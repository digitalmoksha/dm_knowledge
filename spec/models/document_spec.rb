require 'rails_helper'

describe DmKnowledge::Document do

  #------------------------------------------------------------------------------
  it 'is valid with a title, original date, and content' do
    expect(FactoryGirl.build(:document)).to be_valid
  end
  
  #------------------------------------------------------------------------------
  it 'is invalid without a title' do
    document = build(:document, title: nil)
    document.valid?
    expect(document.errors[:title]).to include("can't be blank")
  end
  
  #------------------------------------------------------------------------------
  it 'is invalid without an original date' do
    document = build(:document, original_date: nil)
    document.valid?
    expect(document.errors[:original_date]).to include("can't be blank")
  end
  
  #------------------------------------------------------------------------------
  it 'is invalid without content' do
    document = build(:document, content: nil)
    document.valid?
    expect(document.errors[:content]).to include("can't be blank")
  end
  
  #------------------------------------------------------------------------------
  it 'has a slug in format of yyyy-mm-dd-title' do
    document = create(:document, title: 'Sample Title', original_date: '2012-03-19 17:00:00')
    expect(document.slug).to eq "2012-03-19-sample-title"
  end

  describe 'document tags' do
    #------------------------------------------------------------------------------
    it 'are seperated by command and allow spaces' do
      document1 = create(:document)
      document1.set_tag_list_on(DmKnowledge::Document.tagcontext_from_srcid(1.12), "sandy beaches, shoe")
      document1.save
      expect(DmKnowledge::Document.document_tag_list).to eq ['sandy beaches', 'shoe']
    end

    #------------------------------------------------------------------------------
    it 'generates a sorted list of unique tags for all documents' do
      document1 = create(:document, title: 'Sample 1')
      document2 = create(:document, title: 'Sample 2')
      document1.set_tag_list_on(DmKnowledge::Document.tagcontext_from_srcid(1.12), "MM_tag1,aa_tag2")
      document1.save
      document2.set_tag_list_on(DmKnowledge::Document.tagcontext_from_srcid(1.34), "bb_tag1,aa_tag2")
      document2.save
      expect(DmKnowledge::Document.document_tag_list).to eq ['aa_tag2', 'bb_tag1', 'MM_tag1']
    end
  
    #------------------------------------------------------------------------------
    it 'returns a tag context string based on the srcid' do
      tagcontext = DmKnowledge::Document.tagcontext_from_srcid(1.12)
      expect(tagcontext).to eq 's_1_12'
    end
  end
end