var Sidebar = Sidebar || {};

Sidebar.RemoteAnnotationList = Backbone.Collection.extend({
  model: Sidebar.Annotation,
  url: 'https://localhost:3000/api/search',
  // url: 'https://localhost:5000/api/search',
  // comparator: function(annotation) {
  //   try {
  //     var startOffset = annotation.get("ranges")[0].startOffset;
  //   }
  //   catch(e) {
  //     console.info("startOffset issue." + e.toString());
  //   }
  //   finally {
  //     return startOffset; // change to startOffset
  //   }
  // },
  initialize: function(options) {
    this.fetch({
      data: options,
      success: this.fetchSuccess,
      error: this.fetchError
    });
    this.deferred = new $.Deferred();
  },
  deferred: Function.constructor.prototype,
  fetchSuccess: function(collection, response) {
      collection.deferred.resolve();
  },
  fetchError: function(collection, response) {
      throw new Error("Fetch did not get annotations from the API");
  }
});
