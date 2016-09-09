var sidebar, subscriber, studio;

var annotation_studio = {
  initialize_annotator: function() {
    sidebar = new Sidebar.App();
    sidebar.token = token;
    //window.sidebar = sidebar;
    //Backbone.history.start({pushState: true }); //, root: window.location});

    var studio = $('#textcontent').annotator(annotatorOptions).annotator('setupPlugins', {}, plugin_options());
    var optionsRichText = {
      editor_enabled: annotationStudioConfig.enableRichTextEditor,
      tinymce: {
        'toolbar': annotationStudioConfig.tinyMCEToolbar,
        'image_dimensions': false
      }
    };

    studio.annotator("addPlugin", "MelCatalogue");

    subscriber = $('#textcontent').annotator().data('annotator');

    if(mobile_device) {
      studio.annotator("addPlugin", "Touch");
    }
    else {
      studio.annotator('addPlugin', 'RichText', optionsRichText);
    }

    // When the annotator loads remote data, update sidebar
    subscriber.subscribe('annotationsLoaded', annotation_studio.loadSidebar);
    subscriber.subscribe('annotationsLoaded', annotation_studio.stopSpinner);
    subscriber.subscribe('annotationsLoaded', annotation_studio.handleHash);
    subscriber.subscribe('annotationEditorShown', annotation_studio.parentIndex);

    // Update all highlights with annotation object data
    subscriber.subscribe('annotationsLoaded', __bind(function(annotations) {
      annotations.map(inlineData); // copies values from object fields to the highlight spans data attributes.
    }, this));

    // Add the UUID to the local annotation object and to the highlight span before saving
    subscriber.subscribe('beforeAnnotationCreated', annotation_studio.createUuid); // creates, if need be, and adds, both to object, and to highlight.
    subscriber.subscribe('beforeAnnotationCreated', annotation_studio.addUserName); // creates, if need be, and adds, both to object, and to highlight.

    // Once the local object has been created, load the sidebar from local data (already contains UUID)
    subscriber.subscribe('annotationCreated', annotation_studio.loadSidebar);
    subscriber.subscribe('annotationCreated', inlineData);

    // When the local object is updated (contains previously created/stored UUID), load the sidebar from local data
    subscriber.subscribe('annotationUpdated', annotation_studio.loadSidebar);
    subscriber.subscribe('annotationDeleted', annotation_studio.deleteFromSidebar);
    $(".annotator-checkbox label").text('My groups can view this annotation');

    sidebar.filtered = $('#visibleannotations').hasClass('active');
    sidebar.sort_editable = sidebar_sort_editable;
    sidebar.subscriber = subscriber;
  },
	selectedTags: [],
  loadOptions: function(overrides) {
    var annotation_categories = [];
    $.each($('#category-chooser button.active'), function(i, j) {
      annotation_categories.push($(j).data('annotation_category_id'));
    });

    var settings = {
      'limit': 1000,
      "groups": groups,
      "subgroups": subgroups,
      'user': filter_user,
      'mode': annotation_studio.getMode(),
      'context': search_context,
      'uri': [location.protocol, '//', location.host, location.pathname].join(''),
      'annotation_categories': annotation_categories
    };

    if($('#tagsearchbox').length && $('#tagsearchbox').val() != '') {
      settings.tags = $('#tagsearchbox').val();
    }

    $.each(overrides, function(i, j) {
      settings[i] = j;
    });

    return settings;
  },
  refreshAnnotations: function() {
    subscriber.loadAnnotations(subscriber.plugins.Store.annotations);
    $('#spinnermodal').modal('hide');
  },
  filterAnnotations: function(overrides) {
    var options = annotation_studio.loadOptions(overrides);
    var reload_data = annotation_studio.reloadAnnotations(options);
    var cleanup_document = annotation_studio.cleanupDocument();
    $.when(reload_data).then(cleanup_document).done(annotation_studio.refreshAnnotations(), annotation_studio.loadSidebar());
  },
  modeFilter: function(event) {
    var overrides = {
      mode: event.target.id
    };
    annotation_studio.filterAnnotations(overrides);
  },
  tagFilter: function(event) {
    $('*[data-role="remove"]').hide();
    var overrides = {};
    annotation_studio.filterAnnotations(overrides);
  },
  tagFilterCheck: function(event) {
	  var parent = $("#annotation-tag-list");
	  var checks = parent.find('input:checkbox:checked');
	  var tags = [];
	  for (var i = 0; i < checks.length; i++)
		  tags.push(checks[i].value);
	  annotation_studio.selectedTags = tags;
    var overrides = {};
	  annotation_studio.filterAnnotations(overrides);
  },
  categoryFilter: function(event) {
    $(event.currentTarget).toggleClass('active').removeAttr('style');
    if($(event.currentTarget).hasClass('active')) {
      $(event.currentTarget).css('background-color', $(event.currentTarget).data('active-color'));
    }
    var overrides = {};
    annotation_studio.filterAnnotations(overrides);
  },
  sortUpdate: function(event) {
    sidebar.listAnnotations(subscriber.dumpAnnotations());
  },
  stopSpinner: function() {
    $('#spinnermodal').modal('hide');
  },
  // Update the sidebar with local annotation data
  loadSidebar: function(annotation) {
    setTimeout(function() {
        sidebar.listAnnotations(subscriber.dumpAnnotations());
    }, 100);
  },
  // Remove all comment icons and load sidebar with local data
  deleteFromSidebar: function(annotation) {
    $(".glyphicon-comment").remove();
    setTimeout(function() {
        sidebar.listAnnotations(subscriber.dumpAnnotations());
    }, 100);
  },
  removeHilites: function() {
    $(".glyphicon-comment").remove();
    var hilites = $('.annotator-hl');
    if (hilites.length > 0) {
      hilites.children().unwrap();
      hilites.contents().unwrap();
    }
    return true;
  },
  handleHash: function(annotation) {
    var hash = window.location.hash
    if (hash.length > 0 && $(hash).length > 0){
      console.info(hash);
      setTimeout(function(){
        $('html,body').animate({scrollTop: $(hash).offset().top - 150}, 500);
      },1000);
    }
  },
  // Create a UUID for a given annotation if needed.
  // Once created, this shouldn\'t be changed.
  createUuid: function(annotation) {
    if (annotation.uuid == null) {
      annotation.uuid = Math.uuid(8, 16);
      console.info("New uuid for annotation: '"+annotation.quote+"': "+ annotation.uuid);
    }
    else {
      console.info("Existing uuid for annotation: '"+annotation.quote+"': "+ annotation.uuid);
    }
  },
  cleanupDocument: function() {
    var dfd = new $.Deferred();
    if (annotation_studio.removeHilites()) {
      console.log("Cleanup complete.");
      dfd.resolve("Cleanup complete.");
    }
    else {
      console.log("Cleanup failed.");
      dfd.reject("Cleanup failed.");
    }
    return dfd.promise();
  },
  reloadAnnotations: function(loadOptions) {
    var dfd = new $.Deferred();
    subscriber.plugins.Store.annotations = [];
    if (subscriber.plugins.Store.loadAnnotationsFromSearch(loadOptions)) {
      setTimeout(function() {
        dfd.resolve("Reload complete.");
      }, 100);
      console.log("Reload complete.");
    }
    else {
      console.log("Reload failed.");
      dfd.reject("Reload failed.");
    }
    return dfd.promise();
  },
  getMode: function() {
    return $('label.viewchoice.active').attr("id") || "user";
  },
  addUserName: function(annotation) {
    if (annotation.username == null) {
      annotation.username = annotation_username;
      console.info("New username for annotation: " + annotation_username);
    }
  },
  parentIndex: function(editor, annotation) {
    if (!annotation.parentIndex > 0) {
      console.log("No current annotation.parentIndex: "+ annotation.parentIndex);
      var node = $(".annotator-hl-temporary");
      var parent = node.parent()[0];
      var parentIndex = $( "#textcontent" ).find( "*" ).index(parent)
      annotation.parentIndex = parentIndex;
      console.log("Added annotation.parentIndex: "+ annotation.parentIndex);
    }
    else {
      console.log("Existing parentIndex: " + annotation.parentIndex + "; not adding a new one.");
    }
  },
  set_document_state: function(state) {
    $.each(state, function(i, button_id) {
      var button = $('#' + button_id);
      if(button.length > 0 && !button.hasClass('active')) {
        if(button.parent().hasClass('btn-group')) {
          button.siblings().removeClass('active');
        }
        button.addClass('active');
        if(button.attr('id').match(/^annotation_category/)) {
          button.css('background-color', $.xcolor.opacity('#FFFFFF', button.data('hex'), 0.4).getHex());
        }
      }
    });
  },
  retrieve_document_state: function() {
    var active_buttons = [];
    $.each($('#toolsmenu .btn.active'), function(i, button) {
      active_buttons.push($(button).attr('id'));
    });
    return active_buttons;
  },
  initialize_default_state_behavior: function() {
    annotation_studio.set_document_state(default_state);

    $('#default_state').on('click', function(e) {
      e.preventDefault();
      var current_state = annotation_studio.retrieve_document_state();
      $.ajax({
        url: '/documents/' + document_slug + '/set_default_state',
        type: 'POST',
        data: { default_state: JSON.stringify(current_state) }
      }).done(function() {
        $('#default_state').removeClass('active');
      });
    });
  },

  take_snapshot: function() {
    var html =  $("#snapshot").html();
    var json = '<script type="text/javascript" id="json-archive">' + JSON.stringify(subscriber.dumpAnnotations()) + '</script>'
    var catCss = $("#annotator-category-styles")[0].textContent;
    var css = '<style type="text/css">';
    css += '.annotator-hl { background: rgba(255, 255, 10, 0.3) } .annotator-hl-active { background: rgba(255, 255, 10, 0.8) }.annotator-hl-filtered { background-color: transparent }';
    css += catCss;
    css += '</style>';
    return css + html + json;
  },

  initialize_document_snapshot: function() {
    $('#snapshot_trigger').click(function(e) {
      e.preventDefault();
      var snapshot = annotation_studio.take_snapshot();
      $.ajax({
        url: '/documents/' + document_slug + '/snapshot',
        type: 'POST',
        data: { snapshot: snapshot }
      }).done(function() {
        $('#snapshot').removeClass('active');
      });
    });
  }

};

jQuery(function($) {
  if(!($('body').attr('id') == 'documents' && $('body').attr('class') == 'show')) {
    return;
  }

  annotation_studio.initialize_default_state_behavior();
  annotation_studio.initialize_document_snapshot();
  annotation_studio.initialize_annotator();

  // these three click and tap handlers manage the rich text editor show and hide on mobile and desktop
  $('.annotator-button').on('tap', function(){
    console.log('button tapped');
    $('.annotator-item').removeClass('hide');
  });

  $('.annotator-adder').on('click', function(){
    $('.annotator-item').removeClass('hide');
  });

  $('.annotator-edit').on('tap', function(){
    $('.annotator-item').removeClass('hide');
  });

  $('.viewchoice').on('click', annotation_studio.modeFilter);

	var tagsElement = $("#annotation-tag-list");
	$("body").on('click', '#annotation-tag-list input', annotation_studio.tagFilterCheck);

  $('#tagsearchbox').tagsinput()
  $('#tagsearchbox').on('itemAdded', annotation_studio.tagFilter);
  $('#tagsearchbox').on('itemRemoved', annotation_studio.tagFilter);

  $(window).scroll(lazyShowAndHideAnnotations);

  // Toggle filtered variable
  $('#visibleannotations').on('click', function(){
    sidebar.filtered = true;
    sidebar.showAndHideAnnotations();
  });
  $('#allannotations').on('click', function(){
    sidebar.filtered = false;
    sidebar.showAllAnnotations();
  });

  $.each($('#category-chooser button'), function(i, j) {
    $(j).data('active-color', $.xcolor.opacity('#FFFFFF', $(j).data('hex'), 0.4).getHex());
    $(j).on('click', annotation_studio.categoryFilter);
  });
  $('#textpositionsort').on('click', {}, annotation_studio.sortUpdate);
  $('#customsort').on('click', {}, annotation_studio.sortUpdate);

});

var lazyShowAndHideAnnotations = _.debounce(
  function() { sidebar.showAndHideAnnotations() },
  30
);
  // Add data attributes to highlights
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  var inlineData = __bind(function(a) {

    if (a.highlights[0] != null) {
      a.highlights[0].id = "hl"+ a.uuid;
      a.highlights[0].title = a.user;
      a.highlights[0].dataset.tags = a.tags.join(",");
      a.highlights[0].dataset.groups = a.groups.join(",");
      a.highlights[0].dataset.subgroups = a.subgroups.join(",");
      a.highlights[0].dataset.username = a.username;
      a.highlights[0].dataset.text = a.text;
    }
    else {
      console.info("Annotation: " + a.uuid + "has no highlights.");
    }
  }, this);

