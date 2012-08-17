jQuery(function ($) {
	$('#textcontent').annotator()
		.annotator('setupPlugins', {}, {
		Auth: {
			token: '<%= @jwt %>'
		},
		Store: {
			prefix: 'http://annotations.herokuapp.com/api',
			// prefix: 'http://localhost:5000/api',
		},
		Filter: false,
		Markdown: true,
	});
});
