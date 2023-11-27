window.addEventListener("load", function() {
  const form = document.getElementById('mc-embedded-rsvp-form');
  form.addEventListener("submit", function(e) {
    e.preventDefault();
    const data = new FormData(form);
    const action = e.target.action;
    fetch(action, {
      method: 'POST',
      body: data,
    })
    .then(() => {
      $('#rsvp-modal').modal('hide');
      alert("Success!");
    })
    .catch((error) => {
        alert(error);
    });
  });
});

$(document).ready(function() {
  $(".add_item_btn").click(function(e) {
    e.preventDefault();
    $("#show_item").prepend(`
                <div class="row">
                  <div class="col-md-4 mb-2 col-xs-offset-1">
                    <input type="text" placeholder="First Name" name="guest_firstname[]" class="form-control" required>
                  </div>
                  <div class="col-md-4 mb-1">
                    <input type="text" placeholder="Last Name" name="guest_lastname[]" class="form-control" required>
                  </div>
                  <div class="col-md-2 mb-2 d-grid">
                    <button class="btn btn-danger remove_item_btn">Remove</button>
                  </div>
                </div>
`)
  });
  $(document).on('click', '.remove_item_btn', function(e) {
    e.preventDefault();
    let row_item = $(this).parent().parent();
    $(row_item).remove();
  });
});
