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
