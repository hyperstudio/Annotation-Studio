Sidebar = window.Sidebar || {};

// model
Sidebar.Annotation = Backbone.Model.extend({
	defaults: {
		user: null,
		quote: null,
		text: null,
		id: null,
		start: null, 
		_id: null,
		annotator_schema_version: "v1.0",
		consumer: "annotationstudio.org",
		created: null,
		updated: null,
		highlights: {},
		permissions: {},
		ranges: {},
		tags: {},
		uri: null
	}
});

// collection
(function () {
	var AnnotationList;

	AnnotationList = Backbone.Collection.extend({
		model: Sidebar.Annotation,
		url: 'http://annotations.herokuapp.com/api/search?uri=' + window.location,
		initialize: function () {
			this.fetch({
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
			throw new Error("Annotations fetch did not get a collection from the API");
		}
	});

	Sidebar.annotations = new AnnotationList();
	AnnotationList = null;
}());


Sidebar.AnnotationView = Backbone.View.extend({
	initialize: function (options) {
		this.template = $('#annotation-template').html();
	},
	render: function () {
		var markup = Mustache.to_html(this.template, this.model.toJSON());
		this.$el.html(markup).attr('id',this.model.get('_id'));
		return this;
	}
});

Sidebar.AnnotationListView = Backbone.View.extend({
	className: "annotations",
	initialize: function (options) {
	    this.well = options.well;
	},
	render: function () {
		var i, len = this.collection.length;
		for (i=0; i < len; i++) {
			this.renderItem(this.collection.models[i]);
		};
		// For some reason, this doesn't work:
		// $(this.well).find(this.className).remove();
		// So for now, I'll hard-code the class to remove.
		$(this.well).find(".annotations").remove();
		this.$el.appendTo(this.options.well);

		$('a.highlightlink').tooltip({placement:'right'});

		// TODO: make the LI the click target, not the finicky little a tag.
		$("a.highlightlink").click(function(event){		
			event.preventDefault();
			$("a.highlightlink").tooltip('hide');
			$("ul.annotation-list li").removeClass('hover');
			var idtarget = this.hash;
			// var linkTop = $(this).offset().top
			$('html,body').animate({scrollTop: $(idtarget).offset().top - 150}, 2000); // Can add a callback parameter to run when animation completes.
		});
		
		return this;
	},
	renderItem: function (model) {
		var item = new Sidebar.AnnotationView({
			"model": model
		});
		item.render().$el.appendTo(this.$el);
	}
});

// application
Sidebar.App = Backbone.Router.extend({
	routes: {
		'list':  'listAnnotations',
		'*path':  'defaultRoute',
	},
	listAnnotations: function () {
		var annotationsList = new Sidebar.AnnotationListView({
			"well": $('.well'),
			"collection": Sidebar.annotations
		});
		Sidebar.annotations.deferred.done(function () {
			annotationsList.render();
		});
		return "Rendered annotationsList";
	},
	defaultRoute: function(path) {
		this.listAnnotations();
	}
});

// bootstrap
Sidebar.app = new Sidebar.App();
Backbone.history.start({pushState: true, root: window.location})
