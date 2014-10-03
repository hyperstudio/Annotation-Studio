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

    // get the text of the document that is being annotated
    function getOriginalText( ) {
        var div = $( "div" )[ 0 ];
        return( jQuery.data( div, "annotation" ) );
    }

    // get any selected text that has been added
    function getHighlightedText( ) {
       return( tinymce.activeEditor.selection.getContent( {format: 'text'} ) );
    }

    function getSearchTerm( ) {
        var term = getOriginalText( );
        var note = getHighlightedText( );
        if( note.length > 0 ) { term = note; }
        return( term );
    }

    editor.addButton('mellink', {
        icon: 'link',
        tooltip: 'Insert/edit link to MEL Catalog object',
        onclick: function( ) {
            search( 'link', getSearchTerm( ) );
        }
    });

    editor.addButton('melimage', {
        icon: 'image',
        tooltip: 'Insert/edit image from MEL catalog',
        onclick: function( ) {
            search( 'image', getSearchTerm( ) );
        }
    });
});

//
// end of file
//