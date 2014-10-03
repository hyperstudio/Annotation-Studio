//
//
//

tinymce.PluginManager.add('melcatalog', function(editor, url) {

    function search( mode, term ) {

        // Open window
        editor.windowManager.open({
            width: 600,
            height: 400,
            url: 'catalog?term=' + term + "&types=people,artwork",
            title: 'Search Melville Electronic Library',
            buttons: [ { text: 'Close', onclick: 'close' } ]
        });
    }

    editor.addButton('mellink', {
        icon: 'link',
        tooltip: 'Insert/edit link to MEL Catalog object',
        onclick: function( ) {
            var term = "test";
            search( 'link', term );
        }
    });

    editor.addButton('melimage', {
        icon: 'image',
        tooltip: 'Insert/edit image from MEL catalog',
        onclick: function( ) {
            var term = "test";
            search( 'image', term );
        }
    });
});

//
// end of file
//