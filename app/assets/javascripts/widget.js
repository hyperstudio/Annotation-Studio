Widget = window.Widget || {};

// Models
Widget.AnnotationRows = Backbone.Model.extend({
	defaults: {
		rows: null,
	}
});

// Models
Widget.Annotation = Backbone.Model.extend({
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
Widget.RemoteAnnotationList = Backbone.Collection.extend({
	model: Widget.Annotation,
    // url: 'http://annotations.mit.edu/api/search',
    url: 'http://localhost:5000/api/search',
	comparator: function(annotation) {
		try {
			var startOffset = annotation.get("ranges")[0].startOffset;
		}
		catch(e) {
			console.info("startOffset issue." + e.toString());
		}
		finally {
			return startOffset; // change to startOffset
		}
	},
	initialize: function (options) {
		console.info(options);
		this.fetch({
			data: options,
			success: this.fetchSuccess,
			error: this.fetchError
		});
		this.deferred = new $.Deferred();
		this.sort();
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
Widget.AnnotationView = Backbone.View.extend({
	tagName: 'td',
	className: 'annotation-item',
	initialize: function (annotation) {
		this.commenttemplate = $('#comment-template').html();
		this.highlighttemplate = $('#highlight-template').html();
		this.mdconverter = new Showdown.converter();
		this.href="#full"+this.model.get("uuid");
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
	 	$(this.el).find("a").click(function(){
		  window.open(this.href, '_blank');
		  return false;
		});
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
Widget.AnnotationListView = Backbone.View.extend({
	el: $("div#annotation-well"),
	initialize: function (options) {
		this.template = $('#annotation-template').html();
	},
	render: function () {
		// Clear out existing annotations
		$("ul#annotation-list").find(".annotation-item").remove();

		// Walk throught the list, and render markdown in the user comment first.
		this.collection.each(function(ann) {
			var annView = new Widget.AnnotationView({model: ann});
			$("ul#annotation-list").append(annView.render().el);
		});
		// this.collection.sort();

		$("li.annotation-item span").tooltip();
		// Bind some events to links
		$("li.annotation-item").click(function(event){});
	}
});

// Application
Widget.App = Backbone.Router.extend({
	routes: {
		'list':  'listAnnotations', 
	},
	// takes an object literal of options for an XHR request.
	listAnnotations: function (options) {
		Widget.annotations = new Widget.RemoteAnnotationList(options);
		var annotationsList = new Widget.AnnotationListView({
			"container": $('#annotation-well'),
			"collection": Widget.annotations
		});
		Widget.annotations.deferred.done(function () {
			annotationsList.render();
			// console.info("Remote: "+ Widget.annotations.toJSON());
		});
	},
});
