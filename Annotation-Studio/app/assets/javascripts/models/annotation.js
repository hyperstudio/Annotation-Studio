var Sidebar = Sidebar || {};

Sidebar.Annotation = Backbone.Model.extend({
  initialize: function(annotationObject) {
//    this.set(annotationObject);
  },
  defaults: {
    user: null,
    quote: null,
    text: null,
    id: null,
  }
});
