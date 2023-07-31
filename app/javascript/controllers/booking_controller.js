import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "saleField",
    "agentField",
    "commField",
    "nettField",
    "agentTenPercentLink",
    "fiftyFiftyLink",
    "agentPercentage",
    "commPercentage"
  ]

  connect() {
    this.updatePercentage()
  }

  calculateTwentyPercent(event) {
    event.preventDefault()

    const saleValue = parseInt(this.saleFieldTarget.value)

    const commValue = saleValue * 0.2

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0

    this.updateNettField()
    this.updatePercentage()
  }

  calculateTenPercent(event) {
    event.preventDefault()

    const saleValue = parseInt(this.saleFieldTarget.value)

    const commValue = saleValue * 0.1

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0

    this.updateNettField()
    this.updatePercentage()
  }

  calculateFiftyFifty(event) {
    event.preventDefault()

    const commValue = parseInt(this.commFieldTarget.value)

    const halfValue = commValue * 0.5
    this.agentFieldTarget.value = halfValue.toFixed(0)

    this.updateNettField()
    this.updatePercentage()
  }

  updateNettField() {
    const saleValue = parseInt(this.saleFieldTarget.value)
    const agentValue = parseInt(this.agentFieldTarget.value)
    const commValue = parseInt(this.commFieldTarget.value)

    const nettValue = saleValue - agentValue - commValue
    this.nettFieldTarget.value = nettValue.toFixed(0)
  }

  updatePercentage() {
    const saleValue = parseInt(this.saleFieldTarget.value)
    const agentValue = parseInt(this.agentFieldTarget.value)
    const commValue = parseInt(this.commFieldTarget.value)

    const bookingAgentPercentage = (agentValue / saleValue) * 100
    const bookingCommissionPercentage = (commValue / saleValue) * 100

    this.agentPercentageTarget.textContent = bookingAgentPercentage.toFixed(0) + '%'
    this.commPercentageTarget.textContent = bookingCommissionPercentage.toFixed(0) + '%'
  }
}
