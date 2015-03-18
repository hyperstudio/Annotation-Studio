//
//
//

tinymce.PluginManager.add('melcatalog', function(editor, url) {

    editor.addButton('mellink', {
        //text: 'placeholder',
        icon: 'link',
        tooltip: 'Insert/edit MEL catalog link',
        onclick: function() {
        }
    });

    editor.addButton('melimage', {
        //text: 'placeholder',
        icon: 'image',
        tooltip: 'Insert/edit MEL catalog image',
        onclick: function() {
        }
    });
});

//
// end of file
//