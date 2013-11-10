/*jshint immed:false*/ /*globals Range*/
(function (module, window, document) {
  /* Helper function to provide support for Function.prototype.bind() in
   * unsupported browsers. NOTE: This method is not equivalent to the
   * specification for bind. An only supports the context argument for
   * simplicity.
   *
   * fn      - The function to bind.
   * context - The value to be used as `this` within the function.
   *
   * Returns a new function bound to the context.
   */
  function bind(fn, context) {
    return fn.bind ? fn.bind(context) : function () {
      return fn.apply(context, arguments);
    };
  }

  /* Checks to see if the element has the class.
   *
   * el        - A DOM element.
   * className - The class to look for.
   *
   * Returns true if the element has the class.
   */
  function hasClass(el, className) {
    if (el.classList) {
      return el.classList.contains(className);
    } else {
      return (new RegExp('\\b' + className + '\\b', 'i')).test(el.className);
    }
  }

  /* Adds a class to the element provided.
   *
   * el        - A DOM element.
   * className - The class to add.
   *
   * Returns nothing.
   */
  function addClass(el, className) {
    if (el.classList) {
      el.classList.add(className);
    } else if (!hasClass(el, className)) {
      el.className += ' ' + className;
    }
  }

  /* Removes a class to the element provided.
   *
   * el        - A DOM element.
   * className - The class to remove.
   *
   * Returns nothing.
   */
  function removeClass(el, className) {
    if (el.classList) {
      el.classList.remove(className);
    } else if (hasClass(el, className)) {
      var regexp = new RegExp('\\b' + className + '\\b', 'i');
      el.className = el.className.split(regexp).join('');
    }
  }

  /* Public: Object for working with text selections using the native Range
   * and Selection objects. This can be used in any browser that supports
   * these API's (and document.caretRangeFromPoint) however it was developed to
   * allow selections to be made in the Android WebKit browser which doesn't
   * natively allow access to selected text via the window.getSelected() method.
   *
   * See: http://dvcs.w3.org/hg/domcore/raw-file/tip/Overview.html#ranges
   * See: http://dvcs.w3.org/hg/editing/raw-file/tip/editing.html#selections
   * See: http://code.google.com/p/android/issues/detail?id=14540
   *
   * options - An object literal of initialisation options.
   *           root: The root node element to watch for clicks.
   *           throttle: Event throttle duration in milliseconds.
   *           enable: If false does not enable the plugin on init.
   *           prefix: Prefix string for CSS classes.
   *           highlightStyles: true if plugin should inject custom highlight
   *           color into the page, can also be a string of css proeprties
   *           (default: false).
   *
   * Examples
   *
   *   // Watch for click events on the root node.
   *   var highlighter = new Highlighter({
   *     root: document.getElementById('content')
   *   });
   *
   *   // Selected text can be accessed with window.getSelection() as normal
   *   // or using the #get() method.
   *   saveButton.addEventListener('click', function () {
   *     var selection = highlighter.get();
   *     if (selection.toString().trim()) {
   *       // Do something.
   *     }
   *   }, false);
   *
   *   // Disable watching for clicks at any time.
   *   highlighter.disable();
   *
   *   // Manually invoke the highlighter.
   *   contentNode.addEventListener('click', function (event) {
   *     var position = highlighter.getFirstPosition(event);
   *     if (position) {
   *       // Higlights the word at the position specified.
   *       highlighter.selectWord(position);
   *     }
   *   }, false);
   *
   * Returns a new instance of Highlighter.
   */
  function Highlighter(options) {
    // Bind all event handlers to the current scope.
    for (var method in this) {
      if (method.indexOf('_on') === 0 && typeof this[method] === 'function') {
        this[method] = bind(this[method], this);
      }
    }

    this.options = options = options || {};
    this.root = options.root || document.documentElement;
    this.prefix = (options.prefix || 'highlighter') + '-';
    this.throttle = options.throttle || 1000 / 60;
    this.selected = null;
    this.handles = {
      start: this.createHandle('start'),
      end:   this.createHandle('end')
    };

    if (options.enable !== false) {
      this.enable();
    }
  }

  Highlighter.prototype = {
    /* Redefine the constructor property. */
    constructor: Highlighter,

    /* Public: Alias for window.getSelection().
     *
     * Examples
     *
     *   var selection = highlighter.get();
     *   if (selection.toString()) {
     *     // Do something.
     *   }
     *
     * Returns a Selection instance.
     */
    get: function () {
      return window.getSelection();
    },

    /* Public: Starts the object watching for clicks on the #root element and
     * appends the handle elements to the DOM.
     *
     * Examples
     *
     *   highlighter.enable();
     *
     * Returns itself.
     */
    enable: function () {
      if (!this.enabled) {
        this.bind(this.root, {click: '_onClick'});
        this.bind(document, {
          tapstart:  '_onDocumentDown',
          mousedown: '_onDocumentDown'
        });

        if (this.options.highlightStyles) {
          this.style = this.createStyle();
          document.getElementsByTagName('head')[0].appendChild(this.style);
        }

        document.body.appendChild(this.handles.start);
        document.body.appendChild(this.handles.end);
        this.hideHandles();
        this.enabled = true;
      }
      return this;
    },

    /* Public: Ends the object watching for clicks on the #root element and
     * removes the handle elements from the DOM.
     *
     * Examples
     *
     *   highlighter.disable();
     *
     * Returns itself.
     */
    disable: function () {
      if (this.enabled) {
        this.unbind(this.root, {click: '_onClick'});
        this.unbind(document, {
          tapstart:  '_onDocumentDown',
          mousedown: '_onDocumentDown'
        });

        if (this.style) {
          this.style.parentNode.removeChild(this.style);
        }

        document.body.removeChild(this.handles.start);
        document.body.removeChild(this.handles.end);

        this.get().removeAllRanges();
        this.showHandles();
        this.enabled = false;
      }
    },

    /* Public: Checks if the listener is currently enabled.
     *
     * Examples
     *
     *   if (highlighter.isEnabled()) {
     *     // Watch for selection changes.
     *   }
     *
     * Returns true if the listener is currently enabled.
     */
    isEnabled: function () {
      return this.enabled;
    },

    /* Public: Selects the range and positions the draggable handles.
     *
     * range - An instance of Range to select.
     *
     * Examples
     *
     *   var range = document.createRange();
     *   // Set start and end positions then…
     *   highlighter.select(range);
     *
     * Returns itself.
     */
    select: function (range) {
      var selection = this.get(),
          top   = window.scrollY,
          left  = window.scrollX,
          rects = range.getClientRects(),
          first = rects[0],
          last  = rects[rects.length - 1];

      selection.removeAllRanges();
      selection.addRange(range);

      this.positionHandles({
        x: first.left + left,
        y: first.top + top + (first.height / 2)
      }, {
        x: last.left + last.width + left,
        y: last.top + top + (last.height / 2)
      });

      this.selected = range;
      return this.showHandles();
    },

    /* Public: Deselects the current selection and hides the handles.
     *
     * Examples
     *
     *   document.addEventListener('click', function (event) {
     *     if (!isInSelected(event)) {
     *       highlighter.deselect();
     *     }
     *   });
     *
     * Returns itself.
     */
    deselect: function () {
      var selected = this.get();
      if (selected) {
        this.selected = null;
        selected.removeAllRanges();
      }
      return this.hideHandles();
    },

    /* Public: Selects the word under the current mouse position. The position
     * object should be relative to the client viewport rather than the
     * document.
     *
     * position - A position object with "x" and "y" properties.
     *
     * Examples
     *
     *   highlighter.selectWord({x: 20, y: 120});
     *
     * Returns itself.
     */
    selectWord: function (position) {
      var word = this.createRange(position);
      if (word) {
        word.expand("word");

        if (word.toString().trim()) {
          this.select(word);
        }
      }
      return this;
    },

    /* Public: Selects a range between two points.
     *
     * start - The Range to start at.
     * end   - The Range to end at.
     *
     * Returns itself.
     */
    selectRange: function (start, end) {
      var range = document.createRange();
      range.setStart(start.startContainer, start.startOffset);
      range.setEnd(end.endContainer, end.endOffset);
      return this.select(range);
    },

    /* Public: Expands the start of the currently selected range to the
     * new point.
     *
     * start - The Range to extend the start position to.
     *
     * Example:
     *
     *   highlighter.expandStart(newRange);
     *
     * Returns itself.
     */
    expandStart: function (start) {
      var current = this.selected, hasChanged;
      if (current) {
        hasChanged = current.startContainer !== start.startContainer ||
                     current.startOffset !== start.startOffset;

        if (hasChanged) {
          this.selectRange(start, current);
        }
      }
      return this;
    },

    /* Public: Expands the end of the currently selected range to the new point.
     *
     * start - The Range to extend the start position to.
     *
     * Example:
     *
     *   highlighter.expandEnd(newRange);
     *
     * Returns itself.
     */
    expandEnd: function (end) {
      var current = this.selected, hasChanged;
      if (current) {
        end.expand("character");
        hasChanged = current.endContainer !== end.endContainer ||
                     current.endOffset !== end.endOffset;

        if (hasChanged) {
          this.selectRange(current, end);
        }
      }
      return this;
    },

    /* Public: Creates a new Range object from the position provided. If no
     * range can be created then null is returned.
     *
     * position - A position object with "x" and "y" properties.
     *
     * Examples
     *
     *   var range = highlighter.createRange({x: 20, y: 120});
     *
     * Returns a new Range instance or null.
     */
    createRange: function (position) {
      // NOTE: This method is not supported by Firefox. There is an
      // Event.rangeParent() method that could be used instead.
      // See: http://clauswitt.com/click-to-split-text-in-the-browser.html
      return document.caretRangeFromPoint(position.x, position.y);
    },

    /* Public: Shows the adjustable handles.
     *
     * Examples
     *
     *   highlighter.showHandles();
     *
     * Returns itself.
     */
    showHandles: function () {
      removeClass(document.documentElement, this.prefix + 'hide');
      return this;
    },

    /* Public: Hides the adjustable handles.
     *
     * Examples
     *
     *   highlighter.hideHandles();
     *
     * Returns itself.
     */
    hideHandles: function () {
      addClass(document.documentElement, this.prefix + 'hide');
      return this;
    },

    /* Public: Extracts a position object from an Event object. On multi-touch
     * devices the method will return the position of the first touch event.
     *
     * event - A browser event object.
     *
     * Examples
     *
     *   contentNode.addEventListener('click', function (event) {
     *     var position = highlighter.getFirstPosition(event);
     *     if (position) {
     *       // Higlights the word at the position specified.
     *       highlighter.selectWord(position);
     *     }
     *   }, false);
     *
     * Returns the position object or null.
     */
    getFirstPosition: function (event, useClient) {
      var firstTouch = event.touches ? event.touches[0] : event;
      if (firstTouch) {
        return {
          x: firstTouch.clientX,
          y: firstTouch.clientY
        };
      }
      return null;
    },

    /* Internal: Adds event listeners to a DOM node. The events should be
     * event/callback pairs. If a callback is passed as a string then it is
     * assumed that it is a method on the current object.
     *
     * node   - A DOM node to bind events to.
     * events - An object of event/callback pairs.
     *
     * Examples
     *
     *   highlighter.bind(domNode, {click: onClick});
     *
     * Returns itself.
     */
    bind: function (node, events) {
      var event, callback;
      for (event in events) {
        if (events.hasOwnProperty(event)) {
          callback = events[event];
          if (typeof callback === 'string') {
            callback = this[callback];
          }
          node.addEventListener(event, callback, false);
        }
      }
      return this;
    },

    /* Internal: Removes event listeners from a DOM node. The events should be
     * event/callback pairs. If a callback is passed as a string then it is
     * assumed that it is a method on the current object.
     *
     * node   - A DOM node to remove listeners from.
     * events - An object of event/callback pairs.
     *
     * Examples
     *
     *   highlighter.unbind(domNode, {click: onClick});
     *
     * Returns itself.
     */
    unbind: function (node, events) {
      var event, callback;
      for (event in events) {
        if (events.hasOwnProperty(event)) {
          callback = events[event];
          if (typeof callback === 'string') {
            callback = this[callback];
          }
          node.removeEventListener(event, callback, false);
        }
      }
      return this;
    },

    /* Internal: Updates the selection based on a moved handle.
     *
     * position      - A position object with "x" and "y" properties.
     * isStartHandle - If the handle moved is the start handle.
     *
     * Returns itself.
     */
    updatePositionByHandle: function (position, isStartHandle) {
      var selected, range, isEndBeforeStart, isStartBeforeEnd;

      // Grab the range for the current position ignoring handle elements.
      this.hideHandles();
      range = this.createRange(position);
      this.showHandles();

      if (range) {
        selected = this.selected;

        // Need to account for end handle being dragged before the start
        // handle in which case the selection needs to be inverted and
        // vice versa.
        isEndBeforeStart = !this._isStartHandle &&
          selected.compareBoundaryPoints(Range.START_TO_START, range) === 1;
        isStartBeforeEnd =  this._isStartHandle &&
          selected.compareBoundaryPoints(Range.END_TO_END, range) === -1;

        // Account for the selection being reversed.
        if (isEndBeforeStart || isStartBeforeEnd) {
          this._isStartHandle = !this._isStartHandle;

          // Collapse the range. false collapses to the end of the range.
          // See: https://developer.mozilla.org/en/DOM/range.collapse
          selected.collapse(isEndBeforeStart);
          if (isEndBeforeStart) {
            this.selectRange(range, selected);
          } else {
            this.selectRange(selected, range);
          }
        } else {
          // Otherwise extend the range depending on the handle dragged.
          this[this._isStartHandle ? 'expandStart' : 'expandEnd'](range);
        }
      }
      return this;
    },

    /* Internal: Checks to see if the provided node is one of the handles.
     *
     * node - A document Node.
     *
     * Examples
     *
     *   highlighter.isHandle(event.target);
     *
     * Returns true if the node is one of the handles.
     */
    isHandle: function (node) {
      return node === this.handles.start || node === this.handles.end;
    },

    /* Internal: Positions the drag handles. If any properties are missing
     * they will be ignored.
     *
     * start - A position object with "x" and "y" properties.
     * end   - A position object with "x" and "y" properties.
     *
     * Returns itself.
     */
    positionHandles: function (start, end) {
      start = start || {};
      end   = end || {};

      if (start.y) {
        this.handles.start.style.top  = start.y + 'px';
      }
      if (start.x) {
        this.handles.start.style.left = start.x + 'px';
      }
      if (end.y) {
        this.handles.end.style.top  = end.y + 'px';
      }
      if (end.x) {
        this.handles.end.style.left = end.x + 'px';
      }

      return this;
    },

    /* Internal: Creates a new handle element and attaches appropriate
     * listeners.
     *
     * className - An class name to add to the element.
     *
     * Returns a new <span> Element.
     */
    createHandle: function (className) {
      var handle = document.createElement('span');

      addClass(handle, this.prefix + 'handle');
      addClass(handle, this.prefix + className);

      this.bind(handle, {
        touchstart: '_onHandleDown',
        mousedown:  '_onHandleDown'
      });

      return handle;
    },

    /* Internal: Creates a style element that can be appended to the page
     * to set the document highlight styles. These can be set using the
     * #highlightStyles option.
     *
     * Examples
     *
     *   var head = document.getElementsByTagName('head')[0];
     *   head.appendChild(highlighter.createStyle);
     *
     * Returns a <style> element.
     */
    createStyle: function () {
      var css = '::selection {$} ::-moz-selection {$} ::-webkit-selection {$}',
          style = document.createElement('style'),
          isStyle = typeof this.options.highlightStyles === 'string',
          content = this.options.highlightStyles;

      content = isStyle ? content : 'background-color: rgb(180, 213, 254)';

      css = css.replace(/\$/g, content);
      style.appendChild(document.createTextNode(css));
      return style;
    },

    /* Event handler that watches for clicks on the root node and selects
     * the word at that position.
     *
     * event - A click Event object.
     *
     * Returns nothing.
     */
    _onClick: function (event) {
      if (!this.selected && !this._cleared) {
        var position = this.getFirstPosition(event);
        if (position) {
          this.selectWord(position);
        }
        event.preventDefault();
      }
    },

    /* Event listener to handle taps/clicks on the document and ensure the
     * current highlight remains selected if tapped or clear it if the tap
     * was elsewhere.
     *
     * event - A tap/click event object.
     *
     * Returns nothing.
     */
    _onDocumentDown: function (event) {
      var position = this.getFirstPosition(event),
          selected = this.selected,
          range, isBeforeStart, isAfterEnd;

      delete this._cleared;
      if (this.selected && position && !this.isHandle(event.target)) {
        range = this.createRange(position);
        isBeforeStart = range.compareBoundaryPoints(Range.START_TO_END, selected) === -1;
        isAfterEnd    = range.compareBoundaryPoints(Range.END_TO_START, selected) === 1;

        if (isBeforeStart || isAfterEnd) {
          this._cleared = true;
          this.deselect();
        }
      }

      if (this.isEnabled()) {
        event.preventDefault();
      }
    },

    /* Handle event handler. Watches for taps/clicks on the handle elements
     * and sets up drag handlers.
     *
     * event - A click/tap Event object.
     *
     * Returns nothing.
     */
    _onHandleDown: function (event) {
      var position = this.getFirstPosition(event);
      if (position && this.selected) {
        this._offset = {
          y: position.y - parseFloat(event.target.style.top)  + window.scrollY,
          x: position.x - parseFloat(event.target.style.left) + window.scrollX
        };

        this._startPosition = this._endPosition = position;
        this._isStartHandle = event.target === this.handles.start;

        this.bind(document, {
          mousemove: '_onHandleMove',
          mouseup:   '_onHandleUp',
          touchmove: '_onHandleMove',
          touchend:  '_onHandleUp'
        });
      }
      event.stopPropagation();
      event.preventDefault();
    },

    /* Handle event handler. Updates the selection and handle position. Also
     * throttles calls to the method to prevent excessive updates.
     *
     * event - A click/tap Event object.
     *
     * Returns nothing.
     */
    _onHandleMove: function (event) {
      var self = this, position;
      event.stopPropagation();
      event.preventDefault();

      if (!this._throttled) {
        this._throttled = setTimeout(function () {
          self._throttled = null;
        }, this.throttle);

        if (this._startPosition) {
          position = this.getFirstPosition(event);
          if (position) {
            position = {
              y: position.y - this._offset.y,
              x: position.x - this._offset.x
            };
            this.updatePositionByHandle(position, this._isStartHandle);
          }
        }
      }
    },

    /* Handle event handler. Removes cached properties and bound event handlers.
     *
     * event - A click/tap Event object.
     *
     * Returns nothing.
     */
    _onHandleUp: function () {
      clearTimeout(this._throttled);

      delete this._isStartHandle;
      delete this._startPosition;
      delete this._endPosition;
      delete this._throttled;
      delete this._offset;

      this.unbind(document, {
        mousemove: '_onHandleMove',
        mouseup:   '_onHandleUp',
        touchmove: '_onHandleMove',
        touchend:  '_onHandleUp'
      });
    }
  };

  if (module.exports) {
    module.exports = Highlighter;
  } else {
    module.Highlighter = Highlighter;
  }
})(typeof module !== 'undefined' ? module : this, this, this.document);
