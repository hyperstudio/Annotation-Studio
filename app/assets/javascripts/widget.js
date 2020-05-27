/*globals Mustache, Backbone */
/*globals documentList */
/*globals Widget:true */

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
		// sort first by document title, which we don't readily have in the object, so we add it if needed.
		// then sort by time in reverse order. Since the sort rank is returned as a string, we can't just return a negative number,
		// so we subtract the time from a really large number.
		return 5000000000000 - moment(annotation.get("created"));
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
    fetchSuccess: function (collection, response, arg3) {
		console.log("ANNOTATION API CALL:", arg3.data);
		console.log("ANNOTATION RESPONSE:", collection.models);
        collection.deferred.resolve();
    },
    fetchError: function (collection, response) {
		console.log("ANNOTATION API ERROR:", response);
        throw new Error("Fetch did not get annotations from the API" + response);
    }
});

// Annotation View
Widget.AnnotationView = Backbone.View.extend({
	tagName: 'li',
	className: 'list-group-item',
	initialize: function (annotation) {
		this.commenttemplate = $('#user-comment-template').html();
		this.highlighttemplate = $('#user-highlight-template').html();
		this.mdconverter = new Showdown.converter();
		this.href="#full"+this.model.get("uuid");
	},
	render: function () {
		$(this.el).find(".highlight.comment img").addClass("thumbnail");
		var txt = this.model.get("text");
		var qt = this.model.get("quote");
		var date = this.model.get("updated");
		if (date)
			this.model.set("formattedDate", window.formatDateTime(date));
		var slug = this.model.get("uri");
		if (slug) {
			slug = slug.split("/");
			slug = slug[slug.length - 1];
			var title = slug;
			if (documentList != null){
				title = documentList[slug];
			}
			this.model.set('title', title);
		}
		var docTitle = this.model.get("doc_title");
		if (docTitle) {
			this.model.set('title', docTitle);
		}

		var groups = this.model.get("groups");
		if (groups && groups.length > 0)
			this.model.set("class", groups[0]);
		if (txt !== "" && txt !== null) { // This annotation contains a comment
			this.mdConvert();
			if (txt.substring(0,3) === "<p>" && txt.slice(-4) === '</p>')
				txt = txt.slice(3,-4);
			this.model.set("text" , txt);
			$(this.el).html(Mustache.to_html(this.commenttemplate, this.model.toJSON()));
		}
		else { // This is just a highlight -- no contents
			if (qt !== "" && qt !== null) { // This annotation contains a comment
					this.model.set("quote" , qt);
				$(this.el).html(Mustache.to_html(this.highlighttemplate, this.model.toJSON()));
			}
		}
		return this;
	},
	mdConvert: function () {
		var userComment = this.model.get("text");
		if (userComment !== "" && userComment !== null) {
			this.model.set("text", this.mdconverter.makeHtml(userComment));
		}
		return this;
	}
});

// Annotation List View
Widget.AnnotationListView = Backbone.View.extend({
	initialize: function (options) {
    this.el = $("ul#"+ options.container);
	},
	render: function () {
		// Clear out existing annotations
    this.$el.empty();
		var self = this;
    // Walk throught the list, and render markdown in the user comment first.
		this.collection.each(function(ann) {
			var annView = new Widget.AnnotationView({model: ann});
      self.el.append(annView.render().el);
		});

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
    };
    var annotationsList = new Widget.AnnotationListView(listOptions);
		Widget.annotations.deferred.done(function () {
			annotationsList.render();
			// Put the annotation count on the tab.
			var id = annotationsList.el[0].id;
			var el = $("#"+id);
			var tabName = el.closest(".tab-pane").attr('id');
			var parent = el.closest(".panel");
			var tab = parent.find(".nav-tabs a[href='#" + tabName + "']");
			var badge = tab.find(".badge");

			// List the count on dashboard without re-querying API just to get count.
			if(annotationsList.collection.length >= 10 && parent[0].id == "dashboard-annotations")
				badge.text("10+");
			else
				badge.text(annotationsList.collection.length);
		});
	}
});