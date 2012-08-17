$(document).ready(function () {
	var studio = $('#textcontent').annotator().data('annotator');
	var addHighlightId;
	var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

	addHighlightId = __bind(function(a) {
		if (a.highlights[0] != null) {
			a.highlights[0].id = "hl"+ a.id;
			a.highlights[0].title = a.user;
		}
	}, this);

	var updateSidebar =	function() {
		Sidebar.annotations.models[0].attributes.rows = $('#textcontent').annotator().data('annotator').plugins.Store.annotations;
		console.info("Backbone app now contains " + Sidebar.annotations.models[0].attributes.rows.length + " Annotations");
		var msg = Sidebar.app.listAnnotations();
		console.info(msg);
	};
	 
	studio.subscribe('annotationsLoaded', __bind(function(annotations) {
		annotations.map(addHighlightId);
	}, this));

	studio.subscribe('annotationUpdated', addHighlightId);
	studio.subscribe('annotationCreated', addHighlightId);

	studio.subscribe('annotationsLoaded', updateSidebar);
	studio.subscribe('annotationUpdated', updateSidebar);
	studio.subscribe('annotationCreated', updateSidebar);
	studio.subscribe('annotationDeleted', updateSidebar);

	$("span.annotator-hl").click(function(event){		
		event.preventDefault();
		$("ul.annotation-list li").removeClass('hover');
		$("a.highlightlink").tooltip('hide');
		var str = this.id.toString();
		var parts = str.match(/(hl)(.+)/).slice(1);
		var targetid = "#sb" + parts[1];

		// Move the main text to the top
		//$('html,body').animate({scrollTop:$(this).offset().top - 85}, 2000);

		// Move the annotation sidebar to the top -- doesn't work most of the time, due to the height of the sidebar.
		// TODO: deal with the events in a more organized way (recompose them in functions)
		$('div.well').animate({scrollTop:$(targetid).offset().top}, 100, function (){
			$(targetid).parent().addClass('hover');
			// $(targetid).tooltip('show');
		});
	});
});
