// Hotkeys actions Controller
//
// Supplement to Hotkeys controller, that holds available actions
//
// Here is an example using a link generator:
// <%= link_to 'Add', some_path, data: { "controller": "hotkeys hotkeys-actions", "hotkeys-bindings-value": {"ctrl+y, command+y": "hotkeys-actions#click"}, "hotkeys-actions-target": "element" }  %>
//
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['element']

  click() {
    this.elementTarget.click()
  }
}
