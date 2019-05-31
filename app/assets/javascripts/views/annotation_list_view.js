var Sidebar = Sidebar || {};

Sidebar.AnnotationListView = Backbone.View.extend({
  el: $("div#annotation-well"),
  initialize: function(options) {
    this.template = $('#annotation-template').html();
    var that = this;

    if(sidebar.sort_editable) {
      // TODO: this.$el no longer works here
      $('ul#annotation-list').sortable({
        handle: '.handle',
	containment: 'parent',
        update: function(event, ui) {
          that.listUpdate();
        }
      });
    }
  },
  listUpdate: function() {
    var manual_sort_positions = {};
    var position = 0;
    $.each($('li.annotation-item'), function(i, e) {
      manual_sort_positions[$(e).find("span.highlightlink").attr("data-highlight").replace(/#hl/, '')] = position;
      position += 1;
    });

    var that = this;
    $.ajax({
      url: annotationStudioConfig.apiURL + '/annotations/positions',
      type: 'POST',
      data: { sort_positions: manual_sort_positions },
      // TODO: Is there a better way to send token here??
      headers: { 'x-annotator-auth-token': sidebar.token }
    }).done(function() {
      // TODO: Is there a better way to set the annotation data here
      $.each(sidebar.subscriber.plugins.Store.annotations, function(i, ann) {
        ann.sort_position = manual_sort_positions[ann.uuid];
      });
    });
  },
  render: function() {
    var collection = this.collection
    // Clear out existing annotations
    $("ul#annotation-list").find(".annotation-item").remove();

    if($('#textpositionsort').hasClass('active')) {
      // Sort the collection by where it appears in the document
      sorted_ids = $('.annotator-hl').map(function(i,e){
        return e.id.substring(2);
      }).toArray();
      collection.each(function(ann) {
        ann.set('order', sorted_ids.indexOf(ann.get('uuid')));
      });
      collection.comparator = function(model) {
        return model.get('order');
      };
    } else {
      collection.comparator = function(model) {
        return model.get('sort_position');
      };
    }

    collection.sort();

    // Walk throught the list, and render markdown in the user comment first.
    collection.each(function(ann) {
      var annView = new Sidebar.AnnotationView({model: ann});
      $("ul#annotation-list").append(annView.render().el);
    });

    $("li.annotation-item span").tooltip();

    // Bind some events to links
    $("span.annotator-hl").click(function(event) {
      $("ul#annotation-list li").removeClass('hover');
      $("span.highlightlink").tooltip('hide');
      var str = this.id.toString();
      var parts = str.match(/(hl)(.+)/).slice(1);
      var targetid = "#sb" + parts[1];

      // TODO: deal with the events in a more organized way (recompose them in functions)
      $('div#annotation-well').animate({scrollTop:$(targetid).offset().top}, 100, function (){
        console.info("Scroll to: "+targetid);
        // $(targetid).parent().addClass('hover');
        $(targetid).trigger("click");
        // $(targetid).tooltip('show'); // disappears after 1 sec?
      });
    });

    // Bind some events to links
    $("li.annotation-item").click(function(event){
      if($(this).hasClass('focuswhite')) {
        return;
      }

      var idtarget = $(this).find("span.highlightlink").attr("data-highlight");

      // Hide all details
      $("ul#annotation-list li").removeClass('hover');
      $("#annotation-well ul#annotation-list li").removeClass('focuswhite');

      // Hide all details
      $("ul#annotation-list li .details").hide();

      // Show all comments
      $("ul#annotation-list li .highlightlink.comment, ul#annotation-list li .highlightlink.highlight").show();

      // Hide these comments
      $(this).find(".comment, .highlight").hide();

      // Show these details
      $(this).find(".details").show(200);

      $(this).addClass("focuswhite");

      //$(this).addClass('hover');

      // console.info("ID target attr from list item click function: "+idtarget);
      $("span.highlightlink").tooltip('hide');

      // $(this).removeClass('hover');

      // console.info("This offset top "+$(this).offset().top);
      // console.info("IdTarget offset top "+$(idtarget).offset().top);
  		var el = $(idtarget);
  		if (el.length > 0) {
        $('html,body').animate({scrollTop: $(idtarget).offset().top - 150}, 500);
        $(".glyphicon-comment").remove();
        $(idtarget).prepend('<i class="glyphicon glyphicon-comment"></i>');
      }
      // event.stopPropagation();
    });

    if(sidebar.sort_editable) {
        if($('#customsort').hasClass('active')) {
            $('ul#annotation-list').sortable('enable').addClass('sorting_on');
        } else {
            $('ul#annotation-list').sortable('disable').removeClass('sorting_on');
        }
    }

    sidebar.showAndHideAnnotations();
  }
});
