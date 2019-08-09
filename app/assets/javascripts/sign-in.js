$(function() {
  $("#manual-login-toggle").click(function(event) {
    event.preventDefault();
    $("#manual-login").slideToggle();
    return false;
  });
});
