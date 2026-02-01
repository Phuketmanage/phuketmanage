import { Controller } from "@hotwired/stimulus"

// Manages dynamic invoice line items (description + amount)
export default class extends Controller {
  static targets = ["list", "template", "row", "total", "project", "houseNo", "houseSelect"]

  connect() {
    this.recalc()
    this.applySelectedHouseOption()
  }

  // --- Invoice lines ---

  add() {
    const fragment = this.templateTarget.content.cloneNode(true)
    this.listTarget.appendChild(fragment)
    this.recalc()
    this.focusLastDescription()
  }

  remove(event) {
    const row = event.target.closest('[data-documents-target="row"]')
    if (!row) return

    // Keep at least one row
    if (this.rowTargets.length <= 1) {
      this.clearRow(row)
      this.recalc()
      return
    }

    row.remove()
    this.recalc()
  }

  recalc() {
    const sum = Array.from(this.amountInputs()).reduce((acc, input) => {
      const v = parseFloat(input.value)
      return acc + (Number.isFinite(v) ? v : 0)
    }, 0)

    if (this.hasTotalTarget) {
      this.totalTarget.textContent = sum.toFixed(2)
    }
  }

  // --- helpers ---

  amountInputs() {
    return this.element.querySelectorAll('input[name="invoice_lines[][amount]"]')
  }

  focusLastDescription() {
    const areas = this.element.querySelectorAll('textarea[name="invoice_lines[][description]"]')
    const last = areas[areas.length - 1]
    if (last) last.focus()
  }

  clearRow(row) {
    const area = row.querySelector('textarea[name="invoice_lines[][description]"]')
    const amount = row.querySelector('input[name="invoice_lines[][amount]"]')
    if (area) area.value = ""
    if (amount) amount.value = ""
  }

  // --- house selection ---

  changeHouse() {
    this.applySelectedHouseOption()
  }

  applySelectedHouseOption() {
    const option = this.houseSelectTarget.selectedOptions[0]
    if (!option) return

    const project = option.dataset.project || ""
    const houseNo = option.dataset.houseNo || ""

    if (this.hasProjectTarget) this.projectTarget.value = project
    if (this.hasHouseNoTarget) this.houseNoTarget.value = houseNo
  }
}
