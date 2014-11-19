window.DmKnowledge = {}

#------------------------------------------------------------------------------
DmKnowledge.add_tags_to_src = (srcid, foundsrc) ->
  if foundsrc == undefined
    foundsrc = $("[srcid='#{srcid}']")
  
  tags = $(foundsrc).data('tags')
  tagblock = ''
  if typeof tags != 'undefined'
    tagblock += "<span class='tag'>#{tag}</span> " for tag in tags

  bubble_html = "<span class='bubble'><span class='tags'>#{tagblock}<i class='add_tag fa fa-tags' data-target='#{srcid}'></i></span></span>"
  bubble      = $(foundsrc).find('> .bubble')
  if bubble.length
    $(bubble).replaceWith(bubble_html)
  else
    $(foundsrc).append(bubble_html)
      
#------------------------------------------------------------------------------
DmKnowledge.update_tags = (srcid, taglist) ->
  foundsrc = $("[srcid='#{srcid}']")
  $(foundsrc).data('tags', taglist)
  DmKnowledge.add_tags_to_src(srcid, foundsrc)
    

$(document).ready ->

  #------------------------------------------------------------------------------
  $('#displayed_document [srcid]').each ->
    # add verse number
    srcid = $(this).attr('srcid')
    $(this).prepend("<sup>#{srcid}</sup>")
    DmKnowledge.add_tags_to_src(srcid)

  # We support spaces in document tags
  #------------------------------------------------------------------------------
  $("#document_tag_field").select2({
      tags: $("#document_tag_field").data('tags'),
      tokenSeparators: [',']
  });

  # When add_tag is clicked, fill in the proper details in the modal
  # dialog for editing tags, and show it
  #------------------------------------------------------------------------------
  $('#displayed_document').on 'click', '.add_tag', (e) ->
    srcid = $(this).data('target')
    tags  = $("#displayed_document [srcid='#{srcid}']").data('tags')
    $('#edit_tags #srcid').val(srcid)
    $('#edit_tags #document_tag_field').select2('val', tags)
    $('#edit_tags').modal('show')