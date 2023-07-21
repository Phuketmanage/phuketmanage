// Get the checkbox element
const checkbox = document.getElementById('checkboxHideUnavailable');

// Get all the divs containing the 'Unavailable' span
const divs = document.querySelectorAll('.col.mb-2');

// Add event listener to the checkbox
checkbox.addEventListener('change', function () {
  // Loop through each div and toggle its visibility
  divs.forEach(function (div) {
    if (div.innerHTML.includes('<span class="badge badge-danger">Unavailable</span>')) {
      div.style.display = checkbox.checked ? 'none' : 'block';
    }
  });
});