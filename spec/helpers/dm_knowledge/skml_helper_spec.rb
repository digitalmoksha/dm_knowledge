require 'rails_helper'

include DmKnowledge::SkmlHelper

describe DmKnowledge::SkmlHelper do

  #------------------------------------------------------------------------------
  describe "skml_to_html" do
    let(:skml) do
<<-SKML
<!--: data-who="someone" data-srcid="1.x" -->
Some text to convert

<!--: data-who="someone" data-srcid="1.x" -->
<foreign>basha</foreign> is telugu

<!--: data-who="someone" data-srcid="1.x" -->
<mantra>
some mantra text
</mantra>

<!--: data-who="someone" data-srcid="1.x" -->
This is a <name>Name</name>

<!--: data-who="someone" data-srcid="1.x" -->
And <verse data-srcid="1.x.y">this is a verse</verse>

<!--: data-who="someone" data-srcid="1.x" -->
And this is <redact>redacted</redact>

<!--: data-who="someone" data-srcid="1.x" -->
<golden>A golden statment</golden>

And **some** regular _Markdown_
SKML
    end

    let(:skml_converted) do
<<-SKML
<p data-who="someone" data-srcid="1.x">Some text to convert</p>

<p data-who="someone" data-srcid="1.x"><span data-foreign="">basha</span> is telugu</p>

<p data-who="someone" data-srcid="1.x"><span data-mantra="">
some mantra text
</span></p>

<p data-who="someone" data-srcid="1.x">This is a <span data-name="">Name</span></p>

<p data-who="someone" data-srcid="1.x">And <span data-verse="" data-srcid="1.x.y">this is a verse</span></p>

<p data-who="someone" data-srcid="1.x">And this is <span data-redact="">        </span></p>

<p data-who="someone" data-srcid="1.x"><q data-golden="">A golden statment</q></p>

<p>And <strong>some</strong> regular <em>Markdown</em></p>
SKML
    end

    it "converts test skml into html" do
      expect(skml_to_html(skml)).to eq skml_converted
    end
    
    it "changes text in redact tag" do
      redact    = "Some <redact>redacted</redact> text"
      redacted  = 'Some <span data-redact="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> text'
      redacted2 = 'Some <span data-redact="">********</span> text'
      expect(skml_redact(redact)).to eq redacted
      expect(skml_redact(redact, '*')).to eq redacted2
    end
  end

  #------------------------------------------------------------------------------
  describe "add_tags_to_verses" do
    let(:skml_pre_tagged) do
<<-SKML
<p data-srcid="1.12">one</p>
<p data-srcid="1.20">two</p>
<p data-srcid="1.21">three</p>
SKML
    end

    let(:skml_tagged) do
<<-SKML
<p data-srcid="1.12" data-tags='["foobar","shoe"]' data-tagid='s_1_12'>one</p>
<p data-srcid="1.20" data-tags='["one","two"]' data-tagid='s_1_20'>two</p>
<p data-srcid="1.21">three</p>
SKML
    end
    
    it "looksup and adds tags to html" do
      document = create(:document, content: skml_pre_tagged)
      document.set_tag_list_on(DmKnowledge::Document.tagcontext_from_srcid('1.12'), "foobar, shoe")
      document.save
      document.set_tag_list_on(DmKnowledge::Document.tagcontext_from_srcid('1.20'), "one, two")
      document.save
      tagged_text = add_tags_to_verses(document, document.content)
      expect(tagged_text).to eq skml_tagged
    end
  end


  #------------------------------------------------------------------------------
  describe "skml_set_srcids" do
    let(:skml_non_numbered) do
<<-SKML
<p data-srcid="1.x">one</p>
<p data-srcid = "1.x">two</p>
<p data-srcid="2.x">three<span data-srcid="2.x.y">four</span></p>
SKML
    end

    let(:skml_numbered) do
<<-SKML
<p data-srcid="1.1">one</p>
<p data-srcid="1.2">two</p>
<p data-srcid="2.1">three<span data-srcid="2.x.y">four</span></p>
SKML
    end

    it "auto-numbers the srcids" do
      expect(skml_set_srcids(skml_non_numbered)).to eq skml_numbered
    end
  end

end