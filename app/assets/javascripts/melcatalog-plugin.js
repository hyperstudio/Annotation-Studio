//
// Provides the MelCatalog plugin for the annotation framework
//

jQuery(function ($) {

    function storeAnnotationText( t ) {
        var div = $( "div" )[ 0 ];
        jQuery.data( div, "annotation", t );
    }

    Annotator.Plugin.MelCatalogue = function (element) {
        return {
            pluginInit: function () {

                this.annotator
                    //.subscribe("beforeAnnotationCreated", function (annotation) {
                    //    console.info("beforeAnnotationCreated: %o", annotation)
                    //})
                    //.subscribe("annotationCreated", function (annotation) {
                    //    console.info("annotationCreated: %o", annotation)
                    //})
                    //.subscribe("beforeAnnotationUpdated", function (annotation) {
                    //    console.info("beforeAnnotationUpdated: %o", annotation)
                    //})
                    //.subscribe("annotationUpdated", function (annotation) {
                    //    console.info("annotationUpdated: %o", annotation)
                    //})
                    //.subscribe("annotationDeleted", function (annotation) {
                    //    console.info("annotationDeleted: %o", annotation)
                    //})
                    .subscribe("annotationEditorShown", function (annotation) {
                        //console.info("annotationEditorShown: %o", annotation)
                        storeAnnotationText( annotation.annotation.quote );
                    })
                    //.subscribe("annotationEditorHidden", function (annotation) {
                    //    console.info("annotationEditorHidden: %o", annotation)
                    //})
                    //.subscribe("annotationEditorSubmit", function (annotation) {
                    //    console.info("annotationEditorSubmit: %o", annotation)
                    //})
                    .subscribe("annotationViewerShown", function (annotation) {
                        //console.info("annotationViewerShown: %o", annotation)

                        // remove all handlers then add a click handler
                        $( ".catalog-popup" ).off( ).attr('target', '_blank');
                        $( ".catalog-popup" ).on( 'click', function( e ) {
                            e.preventDefault( );
                            $('.ekko-lightbox').remove();
                            $( this ).ekkoLightbox( );
                            $('.ekko-lightbox .modal-dialog').draggable().resizable();
                        } );
                    })
                    //.subscribe("annotationViewerTextField", function (annotation) {
                    //    console.info("annotationViewerTextField: %o", annotation)
                    //});
            }
        }
    };
});

//
// end of file
//
