onInitializeListeners = [];
onInitializeListeners.push(function() {
  $('#builder-coordinate-submit').click(function(e) {
    e.preventDefault();
    var form = $(this).closest('form');
    var x = form.find('input[name="x"]').val();
    var y = form.find('input[name="y"]').val();
    var start_direction = form.find('#start_direction').val();
    window.location.href = jQuery.query.set("x", x).set("y", y).set("start_direction", start_direction).toString();
  });
});
