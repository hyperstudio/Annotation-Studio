//
//
//

tinymce.PluginManager.add('melcatalog', function(editor, url) {

    function search( mode, term ) {

        var url = "catalog?term=" + term + "&types=people,artwork&onlyimages=" + ( ( mode == 'link' ) ? "false" : "true" );
        jQuery.popupWindow( url, {
            center: 'parent',
            resizable: true,
            createNew: false,
            menubar: false,
            name: "search_popup",
            onUnload: function() {
                insertSelectedEntry( );
            }
        } );

        // Open window
        //editor.windowManager.open({
        //    width: 600,
        //    height: 400,
        //    url: url,
        //    title: 'Search Melville Electronic Library',
        //    resizable: true,
        //    buttons: [ { text: 'Close', onclick: 'submit' } ],
        //    onSubmit: function(e) {
        //        // Insert content when the window form is submitted
        //        //editor.insertContent('Title: ' + e.data.title);
        //        alert( "closed..." );
        //    }
        //});
    }

    // insert the selected item into the annotation text
    function insertSelectedEntry( ) {
        var details = getCatalogDetails( );
        if( details.length != 0 ) {
            alert("Got [" + details + "] in plugin handler");
        }
    }

    // get the text of the document that is being annotated
    function getOriginalText( ) {
        var div = $( "div" )[ 0 ];
        return( jQuery.data( div, "annotation" ) );
    }

    // get anything to be added from the catalog
    function getCatalogDetails( ) {
        var div = $( "div" )[ 0 ];
        var result = jQuery.data( div, "catalog" )
        jQuery.data( div, "catalog", "" );
        return( result );
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