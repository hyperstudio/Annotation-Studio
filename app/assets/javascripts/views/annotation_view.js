var Sidebar = Sidebar || {};

Sidebar.AnnotationView = Backbone.View.extend({
  tagName: 'li',
  className: 'annotation-item',
  initialize: function(annotation) {
    this.commenttemplate = $('#comment-template').html();
    this.highlighttemplate = $('#highlight-template').html();
    this.mdconverter = new Showdown.converter();
    this.href="#full"+this.model.get("uuid");
  },
  render: function() {
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
  mdConvert: function() {
    var userComment = this.model.get("text");
    if (userComment != "") {
      var formattedComment = this.mdconverter.makeHtml(userComment);
      // Temporarily converting to text-only comment due to sidebar formatting issues
      var textComment = $(formattedComment).text()
      this.model.set("text", formattedComment);
    }
    return this;
  }
});
