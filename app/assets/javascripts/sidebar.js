Sidebar = window.Sidebar || {};

// Models
Sidebar.AnnotationRows = Backbone.Model.extend({
	defaults: {
		rows: null,
	}
});

// Models
Sidebar.Annotation = Backbone.Model.extend({
	initialize: function (annotationObject) {
		this.set(annotationObject);
	},
	defaults: {
		user: null,
		quote: null,
		text: null,
		id: null,
	}
});

// Collection
Sidebar.AnnotationList = Backbone.Collection.extend({
	model: Sidebar.Annotation,
    url: 'http://annotations.mit.edu/api/search',
	// comparator: function(annotation) {
	// 	return annotation.get("ranges")[0].startOffset; // change to startOffset
	// },
	initialize: function (options) {
		//console.info(options);
		this.fetch({
			data: options,
			success: this.fetchSuccess,
			error: this.fetchError
		});
		this.deferred = new $.Deferred();
	},
    deferred: Function.constructor.prototype,
    fetchSuccess: function (collection, response) {
        collection.deferred.resolve();
    },
    fetchError: function (collection, response) {
        throw new Error("Fetch did not get annotations from the API");
    }
});

// Annotation View
Sidebar.AnnotationView = Backbone.View.extend({
	tagName: 'li',
	className: 'annotation-item',
	initialize: function (annotation) {
		this.commenttemplate = $('#comment-template').html();
		this.highlighttemplate = $('#highlight-template').html();
		this.mdconverter = new Showdown.converter();
		this.href="#full"+this.model.get("id");
	},
	render: function () {
		$(this.el).find("highlight.comment img").addClass("thumbnail");

		// This annotation contains a comment
		if (this.model.get("text") != "") {
			this.mdConvert();
			$(this.el).html(Mustache.to_html(this.commenttemplate, this.model.toJSON())); // instead of console.info: 
		}

		// This is just a highlight -- no contents
		else {
			$(this.el).html(Mustache.to_html(this.highlighttemplate, this.model.toJSON())); // instead of console.info: 
		}
		$(this.el).find(".details").hide();
		return this;
	},
	mdConvert: function () {
		var userComment = this.model.get("text");
		if (userComment != "") {
			this.model.set("text", this.mdconverter.makeHtml(userComment));
		}
		return this;
	}
});

// Annotation List View
Sidebar.AnnotationListView = Backbone.View.extend({
	el: $("div#annotation-well"),
	initialize: function (options) {
		this.template = $('#annotation-template').html();
	},
	render: function () {
		// Clear out existing annotations
		$("ul#annotation-list").find(".annotation-item").remove();

		// Walk throught the list, and render markdown in the user comment first.
		// this.collection.sort();
		this.collection.each(function(ann) {
			var annView = new Sidebar.AnnotationView({model: ann});
			$("ul#annotation-list").append(annView.render().el);
		});

		// Bind some events to links
		$("span.annotator-hl").click(function(event){
			$("ul#annotation-list li").removeClass('hover');
			$("span.highlightlink").tooltip('hide');
			var str = this.id.toString();
			var parts = str.match(/(hl)(.+)/).slice(1);
			var targetid = "#sb" + parts[1];

			// TODO: deal with the events in a more organized way (recompose them in functions)
			$('div.well').animate({scrollTop:$(targetid).offset().top}, 100
			, function (){
				$(targetid).parent().addClass('hover');
				// $(targetid).tooltip('show'); // disappears after 1 sec?
			}
			);
		});

		// Bind some events to links
		// $('span.highlightlink').tooltip({placement:'right'});

		// Bind some events to links
		$("li.annotation-item").click(function(event){
			var idtarget = $(this).find("span.highlightlink").attr("data-highlight");

			// Hide all details
			$("ul#annotation-list li .details").hide();

			// Show all comments
			$("ul#annotation-list li .highlightlink.comment, ul#annotation-list li .highlightlink.highlight").show();

			// Hide these comments
			$(this).find(".comment, .highlight").hide();

			// Show these details
			$(this).find(".details").show(200);

			//$(this).addClass('hover');

			// console.info(idtarget);
			$("span.highlightlink").tooltip('hide');
			// $(this).removeClass('hover');

			// console.info("This offset top "+$(this).offset().top);
			// console.info("IdTarget offset top "+$(idtarget).offset().top);
			$('html,body').animate({scrollTop: $(idtarget).offset().top - 150}, 500);
			$(".icon-comment").remove();
			$(idtarget).prepend('<i class="icon-comment"></i>');
			event.stopPropagation();		
		});
	}
});

// Application
Sidebar.App = Backbone.Router.extend({
	// Not invoked by user actions; only called from the page script.
	routes: {
		'list':  'listAnnotations'
	},
	// listAnnotations: function (annotationArray) {
	// 	Sidebar.annotations = new Sidebar.AnnotationList(annotationArray, false);
	// 	var annotationsList = new Sidebar.AnnotationListView({
	// 		"container": $('.well'),
	// 		"collection": Sidebar.annotations
	// 	});
	// 	annotationsList.render();
	// },
	updateAnnotations: function (options) {
		Sidebar.annotations = new Sidebar.AnnotationList(options);
		var annotationsList = new Sidebar.AnnotationListView({
			"container": $('.well'),
			"collection": Sidebar.annotations
		});
		Sidebar.annotations.deferred.done(function () {
			console.info(Sidebar.annotations.toJSON());
		});

		// console.info(annotationsList);
		
		// annotationsList.render();
	},
	// renderAnnotation: function (annotationObject) {
	// 	var annotation = new Sidebar.Annotation(annotationObject);
	// 	var annotationView = new Sidebar.AnnotationView({
	// 		"model": annotation
	// 	});
	// 	annotationView.render();
	// 	Sidebar.App.listAnnotations();
	// },
	// deleteAnnotation: function (annotationObject) {
	// 	annotationView.render();
	// 	Sidebar.App.listAnnotations();
	// }
});
