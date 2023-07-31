import { Controller } from "@hotwired/stimulus"
import { put } from "@rails/request.js";
import Sortable from 'sortablejs';


export default class extends Controller {
  static values = {
    group: String
  }

  connect() {
    this.sortable = Sortable.create(this.element, {
      onEnd: this.onEnd.bind(this),
      group: this.groupValue
    });
  }

  onEnd(event) {
    var sortableUpdateUrl = event.item.dataset.sortableUpdateUrl
    var newIndex = event.newIndex
    put(sortableUpdateUrl, {
      body: JSON.stringify({position: newIndex}),
    })
  }
}
