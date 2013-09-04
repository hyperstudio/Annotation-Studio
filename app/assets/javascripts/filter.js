Filter = window.Filter || {};

// Models
Filter.AnnotationRows = Backbone.Model.extend({
	defaults: {
		rows: null,
	}
});

// Models
Filter.Annotation = Backbone.Model.extend({
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
Filter.RemoteAnnotationList = Backbone.Collection.extend({
	model: Filter.Annotation,
	comparator: function(annotation) {
		return - moment(annotation.get("created"));
	},
	initialize: function (options, endpoint, token) {
		this.url = endpoint + "/search";
		this.fetch({
			headers: {'x-annotator-auth-token': token},
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
        throw new Error("Fetch did not get annotations from the API" + response);
    }
});

// Annotation View
Filter.AnnotationView = Backbone.View.extend({
	tagName: 'li',
	className: 'annotation-item',
	initialize: function (annotation) {
		this.commenttemplate = $('#user-comment-template').html();
		this.highlighttemplate = $('#user-highlight-template').html();
		this.mdconverter = new Showdown.converter();
		this.href="#full"+this.model.get("uuid");
	},
	render: function () {
		$(this.el).find("highlight.comment img").addClass("thumbnail");
		var txt = this.model.get("text");
		var qt = this.model.get("quote");
		
		if (txt != "") { // This annotation contains a comment
			this.mdConvert(txt);
			$(this.el).html(Mustache.to_html(this.commenttemplate, this.model.toJSON()));
		}
		else { // This is just a highlight -- no contents
			if (qt != "") { // This annotation contains a comment
				$(this.el).html(Mustache.to_html(this.highlighttemplate, this.model.toJSON()));
			}
		}
		return this;
	},
	mdConvert: function (txt) {
		if (txt != "") {
			this.model.set("text", this.mdconverter.makeHtml(txt));
		}
		return this;
	}
});

// Annotation List View
Filter.AnnotationListView = Backbone.View.extend({
	el: $("ul#annotation-list"),
	initialize: function (options) {
		this.template = $('#annotation-template').html();
	},
	render: function () {
		// Clear out existing annotations
		$("ul#annotation-list").find(".annotation-item").remove();

		// Walk throught the list, and render markdown in the user comment first.
		this.collection.each(function(ann) {
			var annView = new Filter.AnnotationView({model: ann});
			$("ul#annotation-list").append(annView.render().el);
		});
	}
});

// Application
Filter.App = Backbone.Router.extend({
	routes: {
		'list':  'listAnnotations', 
	},
	// takes an object literal of options for an XHR request.
	listAnnotations: function (options, endpoint, token) {
		Filter.annotations = new Filter.RemoteAnnotationList(options, endpoint, token);
		var annotationsList = new Filter.AnnotationListView({
			"container": $('#annotation-list'),
			"collection": Filter.annotations
		});
		Filter.annotations.deferred.done(function () {
			annotationsList.render();
			// console.info("Remote: "+ Filter.annotations.toJSON());
		});
	},
});
