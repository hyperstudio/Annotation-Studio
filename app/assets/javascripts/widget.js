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
Widget.AnnotationView = Backbone.View.extend({
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
			this.mdConvert();
			if (txt.length > 50) {
				this.model.set("text" , txt.substring(0,50) + "...");
			}
			else{
				this.model.set("text" , txt);
			}
			$(this.el).html(Mustache.to_html(this.commenttemplate, this.model.toJSON()));
		}
		else { // This is just a highlight -- no contents
			if (qt != "") { // This annotation contains a comment
				if (qt.length > 50) {
					this.model.set("quote" , qt.substring(0,50) + "...");
				}
				else {
					this.model.set("quote" , qt);
				}
				$(this.el).html(Mustache.to_html(this.highlighttemplate, this.model.toJSON()));
			}
		}
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
  // el: $("ul#" + options.container),
	initialize: function (options) {
    this.el = $("ul#"+ options.container);
	},
	render: function () {
		// Clear out existing annotations
		// $(this.el).find(".annotation-item").remove();
    this.$el.empty();
		var self = this;
    // Walk throught the list, and render markdown in the user comment first.
		this.collection.each(function(ann) {
			var annView = new Widget.AnnotationView({model: ann});
      // console.log(annView.render().el);
      // console.log(self.el);
      self.el.append(annView.render().el);
		});

    // this.collection.each(function(contact) { // iterate through the collection
    //   var contactView = new ContactView({model: contact});
    //   self.$el.append(contactView.el);
    // });

    return self;

	}
});

// Application
Widget.App = Backbone.Router.extend({
	routes: {
		'list':  'listAnnotations',
	},
	// takes an object literal of options for an XHR request.
  listAnnotations: function (listid, options, endpoint, token) {
    Widget.annotations = new Widget.RemoteAnnotationList(options, endpoint, token);
    var listOptions = {
      "container": listid,
      "collection": Widget.annotations
    }
    var annotationsList = new Widget.AnnotationListView(listOptions);
		Widget.annotations.deferred.done(function () {
			annotationsList.render();
			// console.info("Remote: "+ Widget.annotations.toJSON());
		});
	},
});
