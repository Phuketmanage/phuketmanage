// Hotkey Controller
//
// Connect it to the link or button element and specify hotkeys. When the hotkey is entered, the link will be clicked.
//
// Here is an example using a link generator:
// <%= link_to 'Add', some_path, data: { "controller": "hotkey", "hotkeys": "Shift + a" } %>
//
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['element']

  connect() {
    document.addEventListener('keydown', this.handleKeyDown.bind(this))
  }

  disconnect() {
    document.removeEventListener('keydown', this.handleKeyDown.bind(this))
  }

  handleKeyDown(event) {
    const hotkeys = this.element.dataset.hotkeys.split('+').map(hotkey => hotkey.trim())
    const keyPressed = event.key.toLowerCase()

    if (hotkeys.includes(keyPressed) && !event.metaKey && !event.ctrlKey) {
      event.preventDefault()
      this.element.click()
    }
  }
}
