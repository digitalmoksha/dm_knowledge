require 'kramdown'

module DmKnowledge::SkmlHelper
  include DmCore::LiquidHelper
  
  # This takes our special format (SKML) and converts it into usable HTML.
  # Non-html tags are converted to special span tags with the original tag
  # name as an attribtue.  The spans keep the tags from formatting like blocks,
  # and CSS can still target specific attributes.
  #
  # Originally considered converting to an intermediate XML format.  However,
  # since Kramdown doesn't understand the non-HTML tags (without an extension),
  # a tag like <speaker> or <mantra> would cause the paragraph parsing to not 
  # incorporate the tag if it was at the start of a line.  This is something to
  # consider at a later time.
  #------------------------------------------------------------------------------
  def skml_to_html(skml, options = {safe: false})
    html = skml || ''
    
    # convert the commented inline attribute list (IAL)
    #   <!--: who="someone" srcid="x.y.z" -->
    # into the Kramdown version of IAL
    #   {: who="someone" srcid="x.y.z" }
    # This allows easy attaching of attributes to a paragraph
    html.gsub!(/<!--:(.*)-->/, '{: \1 }')

    # convert [:name:] into <speaker>name</speaker>
    html.gsub!(/\[:(.*):\]/, '<speaker>\1</speaker>')

    # convert tagname into  <span tagname>...</span>
    span_tags = %w[foreign mantra speaker name verse redact]
    span_tags.each do |tag|
      html.gsub! "<#{tag}", "<span #{tag}"
      html.gsub! "</#{tag}>", "</span>"
    end

    # convert <golden> tag into <q type="golden">...</q>
    # (based on format of <q> tag in TEI)
    q_tags = %w[golden]
    q_tags.each do |tag|
      html.gsub! "<#{tag}", "<q type=\"#{tag}\""
      html.gsub! "</#{tag}>", "</q>"
    end

    html = ::Kramdown::Document.new(html, parse_block_html: true).to_html.html_safe
    return options[:safe] ? sanitize_text(html, level: :relaxed).html_safe : html
  end

  # add any tag references alongside the srcid
  # note: can't use gsub and $1 on a SafeBuffer, so convert with `to_str`
  #------------------------------------------------------------------------------
  def add_tags_to_verses(document, text)
    html = text.to_str
    html.gsub!(/srcid\s?=\s?['"](.*?)['"]/) do |match|
      tagid     = DmKnowledge::Document.tagcontext_from_srcid($1)
      tag_list  = document.tag_list_on(tagid)
      unless tag_list.empty?
        "#{match} data-tags='#{tag_list.to_json}' data-tagid='#{tagid}'"
      else
        match
      end
    end
    html.html_safe
  end
  
  # Auto-number the srcids.  Very simple methodology - find all 
  # srcids like '*.x' and number it.  If portion before the 'x'
  # changes, then start the numbering over.
  # Note: this function has no idea whether the text has been
  # numbered before or not.
  # Note: currently can't handle sub-verses (1.x.y)
  #
  # Matches 
  #   srcid = "2.x"
  #   srcid="1.x"
  #   srcid = ".x"
  # but not
  #   srcid = "1.x.y"
  #------------------------------------------------------------------------------
  def skml_set_srcids(skml)
    verse   = 0
    chapter = ''
    skml.gsub!(/srcid\s?=\s?['"](.*\.)(x)['"]/) do |match|
      if chapter != $1
        chapter = $1
        verse   = 0
      end
      verse += 1
      "srcid=\"#{chapter}#{verse}\""
    end
    return skml
  end
end