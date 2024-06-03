// app/javascript/controllers/read_checkbox_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "label"]

  connect() {
    this.checkboxTargets.forEach(checkbox => {
      checkbox.addEventListener('change', this.handleCheckboxChange.bind(this))
    })
    // Initial label text setup
    this.checkboxTargets.forEach(checkbox => {
      this.updateLabelText(checkbox)
    })
  }

  handleCheckboxChange(event) {
    const checkbox = event.target
    this.updateReadStatus(checkbox)
    this.updateLabelText(checkbox)
  }

  updateReadStatus(checkbox) {
    const readStatus = checkbox.checked
    const url = checkbox.dataset.url

    fetch(url, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({
        book: { read: readStatus }
      })
    }).then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok')
      }
      return response.json()
    }).catch(error => {
      console.error('There was a problem with the fetch operation:', error)
    })
  }

  updateLabelText(checkbox) {
    const label = checkbox.nextElementSibling
    if (checkbox.checked) {
      label.textContent = "Lu"
    } else {
      label.textContent = "À lire"
    }
  }
}
