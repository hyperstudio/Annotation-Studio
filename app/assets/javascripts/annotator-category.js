var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __hasProp = {}.hasOwnProperty;

Annotator.Plugin.Categories = (function(_super) {
  __extends(Categories, _super);

  Categories.prototype.field = null;

  Categories.prototype.input = null;

  Categories.prototype.options = {
    categories: {}
  };

  function Categories(element, categories) {
    this.loadCategories = __bind(this.loadCategories, this);
    this.updateField = __bind(this.updateField, this);
    this.updateViewer = __bind(this.updateViewer, this);
    this.addHighlightMarkup = __bind(this.addHighlightMarkup, this);
    this.updateHighlightMarkup = __bind(this.updateHighlightMarkup, this);
    this.updateHighlightRules = __bind(this.updateHighlightRules, this);
    this.options.categories = categories;
  }

  Categories.prototype.pluginInit = function() {
    if (!Annotator.supported()) {
      return;
    }

    //FIXME: this.events isn't working for this mapping, so instead, this:
    this.annotator.subscribe("annotationEditorSubmit", this.setAnnotationCat);
    this.annotator.subscribe("annotationCreated", this.addHighlightMarkup);
    this.annotator.subscribe("annotationUpdated", this.updateHighlightMarkup);
    this.annotator.subscribe("annotationsLoaded", this.loadCategories);

    var cat, color, i, isChecked, _ref;

    i = 0;
    _ref = this.options.categories;

    if(Object.keys(_ref).length > 0) {
      this.annotator.editor.addField({
        id: "annotation-category",
        label: 'category',
        type: 'input',
        load: this.updateField
      });

      $('head').append(
        $('<style/>', {
          id: 'annotator-category-styles',
          html: ''
        })
      );

      var category_li = $('#annotation-category').parent();
      category_li.attr('id', 'annotation-category-selection');
      for (cat in _ref) {
        var category = _ref[cat];
        var button = $('<button>').attr('class', 'btn btn-default').attr('value', cat).text(category.name);
        button.data('active-color', $.xcolor.opacity('#FFFFFF', category.hex, 0.4).getHex());
        button.click(function(e) {
          e.preventDefault();
          $(this).toggleClass('active').removeAttr('style');
          if($(this).hasClass('active')) {
            $(this).css('background-color', $(this).data('active-color'));
          }
        });
        category_li.append(button);
      }
      $('#annotation-category').hide();
    }

    this.viewer = this.annotator.viewer.addField({
      load: this.updateViewer
    });
    if (this.annotator.plugins.Filter) {
      this.annotator.plugins.Filter.addFilter({
        label: 'Categories',
        property: 'category',
        isFiltered: Annotator.Plugin.Categories.filterCallback
      });
    }
    return this.input = $(this.field).find(':input');
  };

  Categories.prototype.loadCategories = function(annotations) {
    var _ref = this.options.categories;
    $.each(annotations, function(i, annotation) {
      if(annotation.annotation_categories !== undefined) {
        var extra_classes = '';
        $.each(annotation.annotation_categories, function(j, category) {
          extra_classes += ' annotation_category-' + category;
          if(_ref[category].css_classes !== undefined &&
             _ref[category].css_classes != '') {
            extra_classes += ' ' + _ref[category].css_classes;
          }
        });
        $(annotation.highlights).addClass(extra_classes);
      }
    });

    this.updateHighlightRules();
  };

  Categories.prototype.setViewer = function(viewer, annotations) {
    var v;
    return v = viewer;
  };

  Categories.prototype.updateField = function(field, annotation) {
    $('#annotation-category-selection button').removeClass('active').removeAttr('style');
    if(annotation.annotation_categories !== undefined) {
      $.each(annotation.annotation_categories, function(i, category) {
        var button = $('#annotation-category-selection button[value="' + category + '"]');
        button.addClass('active').removeAttr('style').css('background-color', button.data('active-color'));
      });
    }
    return;
  };

  Categories.prototype.addHighlightMarkup = function(annotation) {
    var h, highlights, _i, _len, _results;
    var _ref = this.options.categories;
    highlights = annotation.highlights;
    if(annotation.annotation_categories !== undefined) {
      _results = [];
      for (_i = 0, _len = highlights.length; _i < _len; _i++) {
        h = highlights[_i];
        var extra_classes = '';
        $.each(annotation.annotation_categories, function(j, category) {
          extra_classes += ' annotation_category-' + category;
          if(_ref[category].css_classes !== undefined &&
             _ref[category].css_classes != '') {
            extra_classes += ' ' + _ref[category].css_classes;
          }
        });
        _results.push(h.className = h.className + extra_classes);
      }
    }

    this.updateHighlightRules();
  };
  Categories.prototype.updateHighlightMarkup = function(annotation) {
    $(annotation.highlights).attr('class', 'annotator-hl');
    this.addHighlightMarkup(annotation);
  };

  Categories.prototype.updateHighlightRules = function() {
    _ref = this.options.categories;

    var total_selectors = new Array();
    $.each($('.annotator-wrapper .annotator-hl'), function(i, child) {
      var this_selector = '';
      var parent_class = '';
      var classes = $(child).attr('class').split(' ');
      for(var j = 0; j<classes.length; j++) {
        if(classes[j].match(/^annotation_category-/)) {
          parent_class += '.' + classes[j];
        }
      }
      if(parent_class != '') {
        this_selector = parent_class;
      }
      $.each($(child).parentsUntil('.annotator-wrapper'), function(j, node) {
        if($(node).is('span.annotator-hl')) {
          var selector_class = '';
          var classes = $(node).attr('class').split(' ');
          for(var j = 0; j<classes.length; j++) {
            if(classes[j].match(/^annotation_category-/)) {
              selector_class += '.' + classes[j];
           }
          }
          if(selector_class != '') {
            this_selector = selector_class + ' ' + this_selector;
          }
        }
      });
      if(this_selector != '') {
        total_selectors.push(this_selector.replace(/ $/, ''));
      }
    });
    var updated = {};
    for(var i = 0; i<total_selectors.length; i++) {
      updated[total_selectors[i]] = 0;
    }
    var updated_rules = '';

    for(var i = 0; i<total_selectors.length; i++) {
      var selector = total_selectors[i];
      if(updated[selector] == 0) {
        var unique_layers = {};
        var layer_count = 0;
        var x = selector.split(' ');
        for(var a = 0; a < x.length; a++) {
          var y = x[a].split('.');
          for(var b = 0; b < y.length; b++) {
            var key = y[b].replace(/^annotation_category-/, '');
            if(key != '') {
              unique_layers[key] = 1;
            }
          }
        }
        var current_hex = '#FFFFFF';
        var key_length = 0;
        $.each(unique_layers, function(key, value) {
          key_length++;
        });
        var opacity = 0.4 / key_length;
        $.each(unique_layers, function(key, value) {
          hex = _ref[key].hex;
          var color_combine = $.xcolor.opacity(current_hex, hex, opacity);
          current_hex = color_combine.getHex();
        });

        updated_rules += selector + ' { background-color: ' + current_hex + '; } ';
        updated[selector] = 1;
      }
    }
    $.each(_ref, function(i, category) {
      if(updated['annotation_category-' + i] === undefined) {
        updated_rules += '.annotation_category-' + i + ' { background-color: ' + $.xcolor.opacity('#FFFFFF', category.hex, 0.4).getHex() + '; } ';
      }
    });

    $('style#annotator-category-styles').html(updated_rules);

    var keys_arr = new Array();
    $.each(updated, function(key, value) {
      keys_arr.push(key);
    });
  };

  Categories.prototype.setAnnotationCat = function(editor) {
    editor.annotation.annotation_categories = [];
    $.each($('#annotation-category-selection button'), function(i, button) {
      if($(button).hasClass('active')) {
        editor.annotation.annotation_categories.push(parseInt($(button).val()));
      }
    });
  };

  Categories.prototype.updateViewer = function(field, annotation) {
    field = $(field);
    var _ref = this.options.categories;
    field.addClass('annotator-category');
    if (annotation.annotation_categories !== undefined && annotation.annotation_categories.length > 0) {
      return field.addClass('annotator-category').html(function() {
        var category_html = '';
        $.each(annotation.annotation_categories, function(i, category) {
          category_html += '<span class="annotation_category_viewer-' +
               category + '">' +
               _ref[category].name +
               '</span>' +
               '<span class="viewer_indicator annotation_category-' + category+ '"></span>';
        });
        return category_html;
      });
    } else {
      return field.remove();
    }
  };

  return Categories;

})(Annotator.Plugin);
