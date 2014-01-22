# Edit of the richText-annotator plugin https://github.com/danielcebrian/richText-annotator
# Converted to CoffeeScript and added two substantive features:
# 1) ability to toggle the richtext editor on/off (while keeping the richtext viewer on)
# 2) added converter from markdown to HTML for easy viewing of legacy markdown annotations. Requires Showdown.

class Annotator.Plugin.RichText extends Annotator.Plugin

  options:
    editor_enabled: true
    tinymce:
      selector: "li.annotator-item textarea",
      plugins: "media image link code",
      link_list: false,
      target_list: false,
      rel_list: false,
      menubar: false,
      statusbar: false,
      toolbar_items_size: 'small',
      extended_valid_elements : "iframe[src|frameborder|style|scrolling|class|width|height|name|align|id]",
      toolbar: "undo redo | styleselect | bold italic | link image media | code"

  mdconverter: if Showdown? then new Showdown.converter() else null

  pluginInit: ->
    annotator = @annotator
    editor = @annotator.editor

    #Check that annotator is working
    return unless Annotator.supported()

    #Viewer setup
    annotator.viewer.addField load: @updateViewer
    return unless @options.editor_enabled

    #Editor Setup
    annotator.editor.addField
      type: "input"
      load: @updateEditor

    annotator.subscribe "annotationEditorShown", ->
      $(annotator.editor.element).find(".mce-tinymce")[0].style.display = "block"
      $(annotator.editor.element).find(".mce-container").css "z-index", 3000000000
      annotator.editor.checkOrientation()

    annotator.subscribe "annotationEditorHidden", ->
      $(annotator.editor.element).find(".mce-tinymce")[0].style.display = "none"

    
    #set listener for tinymce;
    @options.tinymce.setup = (ed) ->
      ed.on "change", (e) ->
        
        #set the modification in the textarea of annotator
        $(editor.element).find("textarea")[0].value = tinymce.activeEditor.getContent()

      ed.on "Init", (ed) ->
        $(".mce-container").css "z-index", "3090000000000000000"

    tinymce.init @options.tinymce

  updateEditor: (field, annotation) =>
    text = (if annotation.text? then annotation.text else "")
    tinymce.activeEditor.setContent @mdConvert text
    $(field).remove() #this is the auto create field by annotator and it is not necessary

  updateViewer: (field, annotation) =>
    textDiv = $(field.parentNode).find("div:first-of-type")[0]
    textDiv.innerHTML = @mdConvert annotation.text
    $(textDiv).addClass "richText-annotation"
    $(field).remove() #this is the auto create field by annotator and it is not necessary

  mdConvert: (txt) =>
    if @mdconverter? and txt isnt "" then @mdconverter.makeHtml txt else txt
