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
    this.updateAgentPercentage()
    this.updateCommissionPercentage()
  }

  calculateAgentPercent(event) {
    event.preventDefault()

    const saleValue = Number(this.saleFieldTarget.value)
    const commValue = Number(this.commFieldTarget.value)

    const agentValue = saleValue * 0.1
    this.agentFieldTarget.value = agentValue.toFixed(0)

    const updatedCommValue = commValue - agentValue
    this.commFieldTarget.value = updatedCommValue.toFixed(0)

    this.updateNettField()
    this.updateAgentPercentage()
    this.updateCommissionPercentage()
  }

  calculateFiftyFifty(event) {
    event.preventDefault()

    const commValue = Number(this.commFieldTarget.value)

    const halfValue = commValue * 0.5
    this.agentFieldTarget.value = halfValue.toFixed(0)
    this.commFieldTarget.value = halfValue.toFixed(0)

    this.updateNettField()
    this.updateAgentPercentage()
    this.updateCommissionPercentage()
  }

  calculateCommPercent(event) {
    event.preventDefault()

    const saleValue = Number(this.saleFieldTarget.value)

    const commValue = saleValue * 0.2

    this.commFieldTarget.value = commValue.toFixed(0)

    this.updateNettField()
    this.updateAgentPercentage()
    this.updateCommissionPercentage()
  }

  updateNettField() {
    const saleValue = Number(this.saleFieldTarget.value)
    const agentValue = Number(this.agentFieldTarget.value)
    const commValue = Number(this.commFieldTarget.value)

    const nettValue = saleValue - agentValue - commValue
    this.nettFieldTarget.value = nettValue.toFixed(0)
  }

  updateAgentPercentage() {
    const saleValue = Number(this.saleFieldTarget.value)
    const agentValue = Number(this.agentFieldTarget.value)

    const bookingAgentPercentage = (agentValue / saleValue) * 100

    this.agentPercentageTarget.textContent = bookingAgentPercentage.toFixed(0) + '%'
  }

  updateCommissionPercentage() {
    const saleValue = Number(this.saleFieldTarget.value)
    const agentValue = Number(this.commFieldTarget.value)

    const bookingCommissionPercentage = (agentValue / saleValue) * 100

    this.commPercentageTarget.textContent = bookingCommissionPercentage.toFixed(0) + '%'
  }
}
