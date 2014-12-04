require 'rails_helper'

describe DmKnowledge::Document do
  setup_account
  
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
    it 'returns a tag context string based on the srcid' do
      expect { DmKnowledge::Document.tagcontext_from_srcid(1.12) }.to raise_error
      expect(DmKnowledge::Document.tagcontext_from_srcid('1.12.34')).to eq 's_1_12_34'
    end

    #------------------------------------------------------------------------------
    it "converts a tag context into a srcid" do
      expect(DmKnowledge::Document.srcid_from_tagcontext('s_1_12')).to eq '1.12'
      expect(DmKnowledge::Document.srcid_from_tagcontext('s_1_12.34')).to eq '1.12.34'
      expect(DmKnowledge::Document.srcid_from_tagcontext('1_12')).to eq nil
    end

    context "creating and finding" do
      before :each do
        @document1 = create(:document, title: 'Sample 1')
        @document1.set_tag_list_on(DmKnowledge::Document.tagcontext_from_srcid('1.12'), "sandy beaches, shoe")
        @document1.save
        @document2 = create(:document, title: 'Sample 2')
        @document2.set_tag_list_on(DmKnowledge::Document.tagcontext_from_srcid('1.34'), "MM_tag1,aa_tag2,shoe")
        @document2.save
      end
      
      #------------------------------------------------------------------------------
      it 'are seperated by command and allow spaces' do
        expect(DmKnowledge::Document.all_tags_list.count).to eq 4
      end

      #------------------------------------------------------------------------------
      it 'generates a sorted list of unique tags for all documents' do
        expect(DmKnowledge::Document.all_tags_list).to eq ['aa_tag2', 'MM_tag1', 'sandy beaches', 'shoe']
      end
  
      #------------------------------------------------------------------------------
      it "replaces a context's tags with a new tag list" do
        srcid = DmKnowledge::Document.tagcontext_from_srcid('1.34')
        @document2.set_tag_list_on(srcid, "tag3, tag4")
        @document2.save
        @document2.reload
        expect(@document2.tag_list_on(srcid)).to eq ['tag3', 'tag4']

        @document2.set_tag_list_on(srcid, nil)
        @document2.save
        expect(@document2.tag_list_on(srcid)).to eq []
      end
      
      describe "finding tags" do
      
        #------------------------------------------------------------------------------
        it "returns array of taggings for a tagname that is found" do
          taggings = DmKnowledge::Document.sources_tagged_with('shoe')
          expect(taggings.count).to eq 2
        end

        #------------------------------------------------------------------------------
        it "returns an empty array for a tagname that is not found" do
          taggings = DmKnowledge::Document.sources_tagged_with('boot')
          expect(taggings.count).to eq 0
        end
        
        #------------------------------------------------------------------------------
        it "returns an array of documents and srcids" do
          @document2.set_tag_list_on('tags', "shoe")
          @document2.save
          taggings  = DmKnowledge::Document.sources_tagged_with('shoe')
          list      = DmKnowledge::Document.tagged_document_list(taggings)
          expect(list.count).to eq 2
          expect(list.first[:document].title).to eq 'Sample 1'
          expect(list.first[:tagged_srcids]).to eq ['1.12']
          expect(list.last[:tagged_srcids]).to eq ['1.34']
          expect(list.last[:document_tagged]).to eq true
        end
        
      end    
    end
  end
end