//
//
//

tinymce.PluginManager.add('melcatalog', function(editor, url) {

    editor.addButton('mellink', {
        //text: 'placeholder',
        icon: 'link',
        tooltip: 'Insert/edit link to MEL Catalog object',
        onclick: function() {
        }
    });

    editor.addButton('melimage', {
        //text: 'placeholder',
        icon: 'image',
        tooltip: 'Insert/edit image from MEL catalog',
        onclick: function() {
        }
    });
});

//
// end of file
//