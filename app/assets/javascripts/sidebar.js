var Sidebar;

function isScrolledIntoView(elem) {
  if (typeof elem !== 'undefined' && $(elem).length > 0) {
    var docViewTop = $(window).scrollTop();
    var docViewBottom = docViewTop + $(window).height();
    var elemTop = $(elem).offset().top;
    var elemBottom = elemTop + $(elem).height();

    return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
  }
  else {
    return false
  }
}
