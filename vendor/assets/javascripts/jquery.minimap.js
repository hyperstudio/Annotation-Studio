(function($) {
  $.fn.minimap = function(settings) {
    var settings = $.extend({
      body_col:    '',
      map_col:     '',
      toggle_btn:  '',
      draggable:   (typeof $.fn.draggable !== 'undefined'),
      scrollto:    (typeof $.fn.scrollTo !== 'undefined'),
      map_header:  '',
      minimap_opacity: '',
      minimap_left_border: '',
      overlay_background_color: ''
    }, settings);

    var body_col = (settings.body_col) ?
          $(settings.body_col) : $(this),
        map_col  = (settings.map_col) ?
          $(settings.map_col) : $( '<aside class="map_col"></aside>' ),
        minimap_opacity = (settings.minimap_opacity) ?
          settings.minimap_opacity : 1,
        minimap_left_border = (settings.minimap_left_border) ?
          settings.minimap_left_border : 'none',
        overlay_background_color = (settings.overlay_background_color) ?
          settings.overlay_background_color : 'rgba(26, 45, 58, .1)';

    var map_header = $(settings.map_header).appendTo( map_col );

    map_col.insertBefore( body_col );

    var miniMapSetup = false,
        scrolling    = false,
        resizing     = false;


    // Performs the inital minimap setup: clones the element defined as the
    // body_column; removes any scripts, links, etc.; and inserts the map column
    // before the body column

    (function() {

      if ( miniMapSetup ) return;

      var miniMapHolder    = map_col,
          miniMapHeight    = miniMapHolder.outerHeight(),
          miniMapOffsetTop = (map_header) ? map_header.outerHeight() : 0,
          miniMapWidth     = miniMapHolder.outerWidth(),
          bodyCol          = body_col,
          bodyHeight       = bodyCol.outerHeight(),
          bodyWidth        = $('.body_col').width() - miniMapWidth,
          scaling          = Math.min(
                               ( miniMapWidth - 12 ) / bodyWidth,
                               ( miniMapHeight - 24 ) / bodyHeight
                             ),
          mapWaypoint;

      var miniMapWrapElt = $('<div></div>')
        .addClass('map-col-background')
        .css({
          position:  'fixed',
          width:     miniMapWidth -1,
          height:    miniMapHeight,
          top:       miniMapOffsetTop,
          overflow:  'hidden',
          borderLeft: minimap_left_border
        })
        .appendTo(miniMapHolder);

      var miniMap = bodyCol
        .clone(false)
        .css({
          background:                  'transparent',
          color:                       'black',
          width:                       bodyWidth,
          position:                    'absolute',
          top:                         '6px',
          right:                       ( miniMapWidth - scaling * bodyWidth ) / 2,
          opacity:                     minimap_opacity,
          'transform':                 'scale('+scaling+')',
          '-ms-transform':             'scale('+scaling+')',
          '-webkit-transform':         'scale('+scaling+')',
          'transform-origin':          'top right',
          '-ms-transform-origin':      'top right',
          '-webkit-transform-origin':  'top right'
        });

      miniMap.find('script').remove();
      miniMap.appendTo( miniMapWrapElt );

      miniMapOverlay = $('<div></div>')
        .css({
          width: '100%',
          height: '100%',
          position: 'absolute',
          top: 0,
          left: 0
        })
        .addClass('mini-map-clickable')
        .appendTo( miniMapWrapElt );

      mapWaypoint = $('<div class="miniMapOverlay ui-draggable"></div>')
        .css({
          background:  overlay_background_color,
          width:       '100%',
          position:    'absolute'
        })
        .appendTo( miniMapWrapElt );


      // Redraw the entire minimap when a window.resize event is detected,
      // in case the resizing may have caused reflow. Also trigger a "scroll"
      // event from here, because the visible viewport will definitely have to
      // be updated.

      $(window).on( 'resize.minimap', function() {
        if ( resizing ) {
          return;
        }
        resizing = true;

        bodyHeight       = bodyCol.height();
        bodyWidth        = bodyCol.width();
        miniMapHeight    = miniMapHolder.outerHeight();
        miniMapWidth     = miniMapHolder.outerWidth();
        miniMapOffsetTop = (map_header) ? map_header.height() : 0;
        winHeight        = $(window).height();
        scaling          = Math.min(
                             ( miniMapWidth - 12 ) / bodyWidth,
                             ( miniMapHeight - 24 ) / bodyHeight
                           );

        miniMapWrapElt.css({
          width:   miniMapWidth -1,
          height:  miniMapHeight
        });

        miniMap.css({
          width:                       bodyWidth,
          right:                       ( miniMapWidth - scaling * bodyWidth ) / 2,
          'transform':                 'scale('+scaling+')',
          '-ms-transform':             'scale('+scaling+')',
          '-webkit-transform':         'scale('+scaling+')',
          'transform-origin':          'top right',
          '-ms-transform-origin':      'top right',
          '-webkit-transform-origin':  'top right'
        });

        $(window).trigger( 'scroll.minimap' );
        resizing = false;
      });


      // Reposition current location marker on minimap when a window.scroll
      // event is detected.

      $(window).on( 'scroll.minimap', function() {

        if ( scrolling ) {
          return;
        }
        scrolling = true;

        var loc       = $(window).scrollTop(),
            winHeight = $(window).height();

        mapWaypoint.css({
          top:     loc * scaling + 6,
          height:  winHeight * scaling
        });

        scrolling = false;
      });

      miniMapSetup = true;

      $('.miniMapOverlay').draggable({
        axis:         'y',
        containment:  'parent',
        drag:         function( event, ui ) {
          // It shouldn't be necessary to look up the actual CSS property of the object,
          // but because of the combination of the CSS transform and the draggable helper,
          // both offset.top and position.top are returning very weird results.
          var dragLoc = parseFloat( $(ui.helper).css('top') ) - 6;
          $(window).scrollTop( dragLoc / scaling );
        }
      });

      $('.mini-map-clickable').click(function(event){
        var clickTop  = event.clientY - $('.map_col').offset().top - 60,
            winHeight = ( $(window).height() - miniMapOffsetTop ) * scaling;
        clickCenter   = Math.max( 0, (clickTop - winHeight / 2) );

        $(window).scrollTop( clickCenter / scaling );
      });

    })();

    // Wait for all content to render before initially scaling the mini-map
    $(window).load(function() {
      utilities.toggle( window.localStorage.getItem('miniMapActive') );
    });

    var utilities = {
      toggle: function(showMap) {
        if (typeof showMap === 'undefined') {
          var vis = window.localStorage.getItem('miniMapActive');
          showMap = !( vis && vis !== 'false' )
        }

        if ( showMap ) {
          $('body').addClass( 'mini-map-active' );
        } else {
          $('body').removeClass( 'mini-map-active' );
        }

        localStorage.setItem( 'miniMapActive', showMap );
        $(window).trigger('resize.minimap');
      },

      show: function() {
        return this.toggle(true)
      },

      hide: function() {
        return this.toggle(false)
      }
    };

    $.minimap = this;
    $.extend( $.minimap, utilities );

  };

}(jQuery));
