# Plugin that renders annotation comments displayed in the Viewer in Markdown.
# Requires Showdown library to be present in the page when initialised.
class Annotator.Plugin.RichText extends Annotator.Plugin
  # Events to be bound to the @element.
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
    text = (if typeof annotation.text isnt "undefined" then annotation.text else "")
    tinymce.activeEditor.setContent text
    $(field).remove() #this is the auto create field by annotator and it is not necessary

  updateViewer: (field, annotation) =>
    textDiv = $(field.parentNode).find("div:first-of-type")[0]
    textDiv.innerHTML = annotation.text
    $(textDiv).addClass "richText-annotation"
    $(field).remove() #this is the auto create field by annotator and it is not necessary