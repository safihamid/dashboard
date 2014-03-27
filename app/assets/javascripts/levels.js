onInitializeListeners = [];
onInitializeListeners.push(function() {
  $('#builder-coordinate-submit').click(function(e) {
    e.preventDefault();
    var form = $(this).closest('form');
    var x = form.find('input[name="x"]').val();
    var y = form.find('input[name="y"]').val();
    window.location.href = jQuery.query.set("x", x).set("y", y).toString();
  });
});
