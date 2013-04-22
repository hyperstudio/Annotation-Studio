var visualSearch = VS.init({
	container : $('.visual_search'),
	query     : '',
	callbacks : {
		facetMatches : function(callback) {
			callback(
				['account', 'filter', 'access', 'title',
					{ label: 'city',    category: 'location' },
					{ label: 'address', category: 'location' },
					{ label: 'country', category: 'location' },
					{ label: 'state',   category: 'location' },
				]
			);
		},
		// These are the values that match specific categories, autocompleted
		// in a category's input field.  searchTerm can be used to filter the
		// list on the server-side, prior to providing a list to the widget.
		valueMatches : function(facet, searchTerm, callback) {
			switch (facet) {
				case 'account':
				    callback([
				      { value: '1-amanda', label: 'Amanda' },
				      { value: '2-aron',   label: 'Aron' },
				      { value: '3-eric',   label: 'Eric' },
				      { value: '4-jeremy', label: 'Jeremy' },
				      { value: '5-samuel', label: 'Samuel' },
				      { value: '6-scott',  label: 'Scott' }
				    ]);
				    break;
				case 'filter':
				  callback(['published', 'unpublished', 'draft']);
				  break;
				case 'access':
				  callback(['public', 'private', 'protected']);
				  break;
				case 'title':
				  callback([
				    'Pentagon Papers',
				    'CoffeeScript Manual',
				    'Laboratory for Object Oriented Thinking',
				    'A Repository Grows in Brooklyn'
				  ]);
					break;
			}
		}
	}
});
