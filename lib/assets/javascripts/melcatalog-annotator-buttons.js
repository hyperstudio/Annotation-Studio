//
//
//

tinymce.PluginManager.add('melcatalog', function( editor ) {

    function search( mode, term ) {

        var url = "catalog?term=" + encodeURI( term ) + "&types=people,artwork&onlyimages=" + ( ( mode == 'image' ) ? "true" : "false" );
        jQuery.popupWindow( url, {
            center: 'parent',
            resizable: true,
            createNew: false,
            menubar: false,
            onUnload: function() {
                insertCatalogReference( mode );
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
    function insertCatalogReference( mode ) {
        var details = getReferenceDetails( );
        if( details !== undefined && details.length != 0 ) {
            //alert("Got [" + details + "] mode [" + mode + "]" );
            var tokens = details.split( "|" );
            if( mode == "image" ) {
                insertImage( tokens[ 0 ], tokens[ 2 ] );
            } else {
                insertReference( tokens[ 0 ], tokens[ 1 ] );
            }
        }
    }

    // insert a link pointing to a catalog item whose title is the name or title of the entry from the catalog
    function insertReference( eid, title ) {
        var url = "/documents/catalog/reference/" + eid;
        var tag = "<a class=\"catalog-popup\" href=\"" + url + "\">" + editor.dom.encode( title ) + "</a>";
        editor.insertContent( tag );
    }

    // insert a link pointing to a catalog image and include the thumbnail
    function insertImage( eid, image_src ) {
        var url = "/documents/catalog/image/" + eid;
        var tag = "<a class=\"catalog-popup\" href=\"" + url + "\"><img src=\"" + image_src + "\"/></a>";
        editor.insertContent( tag );
    }

    // get the text of the document that is being annotated
    function getOriginalText( ) {
        var div = $( "div" )[ 0 ];
        return( jQuery.data( div, "annotation" ) );
    }

    // get anything to be added from the catalog
    function getReferenceDetails( ) {
        var div = $( "div" )[ 0 ];
        var result = jQuery.data( div, "catalog" )
        jQuery.data( div, "catalog", "" );
        return( result );
    }

    // get any selected text that has been added
    function getHighlightedText( ) {
       return( tinymce.activeEditor.selection.getContent( {format: 'text'} ) );
    }

    // determine the search term by looking at what text is highlighted. Text highlighted in the
    // annotation box supersedes text highlighted on the document
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
            search( 'reference', getSearchTerm( ) );
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