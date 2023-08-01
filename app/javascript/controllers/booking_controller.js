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

  calculateTwentyPercent() {
    const saleValue = parseInt(this.saleFieldTarget.value)

    const commValue = saleValue * 0.2

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0

    this.updateNettField()
    this.updatePercentage()
  }

  calculateTenPercent() {
    const saleValue = Number(this.saleFieldTarget.value)

    const commValue = saleValue * 0.1

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0

    this.updateNettField()
    this.updatePercentage()
  }

  calculateFiftyFifty() {
    const commValue = Number(this.commFieldTarget.value)

    const halfValue = commValue * 0.5

    this.agentFieldTarget.value = halfValue.toFixed(0)

    this.updateNettField()
    this.updatePercentage()
  }

  updateNettField() {
    const saleValue = Number(this.saleFieldTarget.value)
    const agentValue = Number(this.agentFieldTarget.value)
    const commValue = Number(this.commFieldTarget.value)

    const nettValue = saleValue - agentValue - commValue

    this.nettFieldTarget.value = nettValue.toFixed(0)
  }

  updatePercentage() {
    const saleValue = Number(this.saleFieldTarget.value)
    const agentValue = Number(this.agentFieldTarget.value)
    const commValue = Number(this.commFieldTarget.value)

    let bookingAgentPercentage = (agentValue / saleValue) * 100
    if (isNaN(bookingAgentPercentage)) {
      bookingAgentPercentage = 0
    }
    let bookingCommissionPercentage = (commValue / saleValue) * 100
    if (isNaN(bookingCommissionPercentage)) {
      bookingCommissionPercentage = 0
    }

    this.agentPercentageTarget.textContent = bookingAgentPercentage.toFixed(0) + '%'
    this.commPercentageTarget.textContent = bookingCommissionPercentage.toFixed(0) + '%'
  }
}
