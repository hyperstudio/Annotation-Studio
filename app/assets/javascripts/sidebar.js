Sidebar = window.Sidebar || {};

// Model
Sidebar.Annotation = Backbone.Model.extend({
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
	comparator: function(annotation) {
		return annotation.get("created"); // change to startOffset
	},
	initialize: function (annotations) {
		// Dump in a whole array of JSON objects -- necessary?
		// this.add(annotations); // don't think it is 
		// console.info("First annotation: " + this.shift().get("quote"));
		this.sort();
	},
});

// Annotation View
Sidebar.AnnotationView = Backbone.View.extend({
	tagName: 'li',
	className: 'annotation-item',
	initialize: function () {
		this.template = $('#annotation-template').html();
		//this.mdconverter = $('#textcontent').annotator().data('annotator').plugins.Markdown.converter;
	},
	render: function () {
		$(this.el).html(Mustache.to_html(this.template, this.model.toJSON())); // instead of console.info: 
		return this;
	},
	mdConvert: function () {
		var userComment = this.model.text;
		if (userComment != null) {
			this.model.text = this.mdconverter.makeHtml(userComment);
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
		$(this.well).find(".annotations").remove();

		// Walk throught the list, and render markdown in the user comment first.
		this.collection.sort();
		this.collection.each(function(ann) {
			var annView = new Sidebar.AnnotationView({model: ann});
			$("ul#annotation-list").append(annView.render().el);
			// console.info(annView);
		});
	}
});

// Application
Sidebar.App = Backbone.Router.extend({
	// Not invoked by user actions; only called from the page script.
	routes: {
		'list':  'listAnnotations'
	},
	listAnnotations: function (annotationArray) {
		Sidebar.annotations = new Sidebar.AnnotationList(annotationArray);
		var annotationsList = new Sidebar.AnnotationListView({
			"container": $('.well'),
			"collection": Sidebar.annotations
		});
		annotationsList.render();
		return "Rendered annotationsList";
	}
});
