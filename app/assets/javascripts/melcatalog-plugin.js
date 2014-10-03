//
// Provides the MelCatalog plugin for the annotation framework
//

jQuery(function ($) {

    Annotator.Plugin.MelCatalogue = function (element) {
        return {
            pluginInit: function () {

                container = $(".mce-container-body");

                //this.annotator.editor.addField({
                //    load: function (field, annotation) {
                //         field.innerHTML = 'bla bla bla';
                //    }
                //});

                //this.annotator
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
                    //.subscribe("annotationEditorShown", function (annotation) {
                    //    console.info("annotationEditorShown: %o", annotation)
                    //})
                    //.subscribe("annotationEditorHidden", function (annotation) {
                    //    console.info("annotationEditorHidden: %o", annotation)
                    //})
                    //.subscribe("annotationEditorSubmit", function (annotation) {
                    //    console.info("annotationEditorSubmit: %o", annotation)
                    //})
                    //.subscribe("annotationViewerShown", function (annotation) {
                    //    console.info("annotationViewerShown: %o", annotation)
                    //})
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