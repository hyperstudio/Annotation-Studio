var snapshot = {
  save: function(storage){
    var xhr = $.ajax({
      url: '/documents/' + document_slug + '/snapshot',
      type: 'POST',
      data: { snapshot: storage.html() }
    }).done(function(){
      console.log("Saved snapshot");
      $("#snapshot-progress").modal("hide");
      console.log("Removed spinner");
    }).fail(function(){
      console.log("Failed to save snapshot");
    });
    // cast jQuery promise to native promise
    return Promise.resolve(xhr);
  },

  addHTML: function(){
    return new Promise(function(resolve, reject){
      var text = $("#snapshot").html();
      if (text.length) {
        resolve(text);
      }
      else {
        reject("Failed to add HTML.");
      }
    });
  },

  addJSON: function(){
    var json = '<script type="text/javascript" id="json-archive">var annotations = ' + JSON.stringify(subscriber.dumpAnnotations()) + '</script>';    
    return new Promise(function(resolve, reject){
      if (json.length) {
        resolve(json);
      }
      else {
        reject("Failed to add JSON.");
      }
    });
  },

  addCSS: function(){
    var catCss = $("#annotator-category-styles")[0].textContent;
    var css = '<style type="text/css">';
    css += '.annotator-hl { background: rgba(255, 255, 10, 0.3) } .annotator-hl-active { background: rgba(255, 255, 10, 0.8) }.annotator-hl-filtered { background-color: transparent }';
    css += catCss;
    css += '</style>';
    return new Promise(function(resolve, reject){
      if (css.length) {
        resolve(css);
      }
      else {
        reject("Failed to add CSS.");
      }
    });
  },

  addFilters: function() {
    var filterLists = {};
    var filterFields = ['tags', 'annotation_categories', 'user'];
    var filterblock = '';

    var requests = _.map(filterFields, function(field){
      var fieldUrl = doc_uri + "/annotations/field/" + field + ".json";
      return Promise.resolve($.get(fieldUrl));
    });

    return requests;
  },

  initialize: function () {
    $('#snapshot_trigger').click(function(e) {
      e.preventDefault();

      $("#snapshot-progress").modal("show");

      $(".glyphicon-comment").remove();

      console.log("Started spinner");

      // Get a reference to in-page storage node
      // Zero out the HTML in the snapshot.
      var storage = $("#snapshot-staging");
      storage.html("");

      // Get promise objects for in-page content
      var css = snapshot.addCSS(storage); // in-page
      var html = snapshot.addHTML(storage); // in-page
      var json = snapshot.addJSON(storage); // in-page

      // Set up an array of promises for fetching metadata (async)
      // each of which returns one key/value pair for a filterlist
      var filterPromises = snapshot.addFilters(storage);

      // Set up an array of promises,
      // each of which grabs some content out of the page
      var sectionPromises = [css, html, json];

      // Promise.all returns when all promises
      // in the array passed to it resolve
      // First, in-page content
      Promise.all(sectionPromises).then(function(sections){
        sections.forEach(function(section){
          storage.append(section);
        });
      // Then, async requests for metadata
      }).then(function(result){
        return Promise.all(filterPromises);
      }).then(function(filters){
        var filterLists = {};
        var filterBlock = '';
        filters.forEach(function(filter){
          $.extend(filterLists, filter)
        });
        filterBlock = '<script type="text/javascript" id="filter-lists">var filterLists = ' + JSON.stringify(filterLists) + '</script>';
        storage.append(filterBlock);
      // Then, async request to store snapshot
      }).then(function(){
        snapshot.save(storage);
      }).catch(function(err) {
        // TODO: Show failure alert
        console.log("Argh, broken: " + err.message);
      });
    }); // end click handler
  }, // end initialize function
}; // end snapshot object
