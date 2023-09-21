import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "saleField",
    "agentField",
    "commField",
    "nettField",
    "agentPercentage",
    "commPercentage",
    "nettPercentage"
  ]

  updatePercentage() {
    let saleValue = parseFloat(this.saleFieldTarget.value) || 1;
    let agentValue = parseFloat(this.agentFieldTarget.value) || 0;
    let commValue = parseFloat(this.commFieldTarget.value) || 0;
    let nettValue = parseFloat(this.nettFieldTarget.value) || 0;

    if (saleValue <= 0 || agentValue < 0 || commValue < 0 || nettValue < 0) {
      this.agentPercentageTarget.textContent = '-';
      this.commPercentageTarget.textContent = '-';
      this.nettPercentageTarget.textContent = '-';
      this.agentPercentageTarget.classList.add('bg-danger');
      this.commPercentageTarget.classList.add('bg-danger');
      this.nettPercentageTarget.classList.add('bg-danger');
    } else {
      // Ensure percentages are not negative
      let bookingAgentPercentage = (agentValue / saleValue) * 100;
      let bookingCommissionPercentage = (commValue / saleValue) * 100;
      let bookingNettPercentage = (nettValue / saleValue) * 100;

      this.agentPercentageTarget.textContent = bookingAgentPercentage.toFixed(0) + '%';
      this.commPercentageTarget.textContent = bookingCommissionPercentage.toFixed(0) + '%';
      this.nettPercentageTarget.textContent = bookingNettPercentage.toFixed(0) + '%';

      if (saleValue === (agentValue + commValue + nettValue)) {
        this.agentPercentageTarget.classList.remove('bg-danger');
        this.commPercentageTarget.classList.remove('bg-danger');
        this.nettPercentageTarget.classList.remove('bg-danger');
      } else {
        this.agentPercentageTarget.classList.add('bg-danger');
        this.commPercentageTarget.classList.add('bg-danger');
        this.nettPercentageTarget.classList.add('bg-danger');
      }
    }
  }

  calculateTwentyPercent() {
    const saleValue = Math.ceil(Number(this.saleFieldTarget.value))

    const commValue = Math.ceil(saleValue * 0.2)

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0
    this.nettFieldTarget.value = saleValue - commValue

    this.updatePercentage()
  }

  calculateTwentyFivePercent() {
    const saleValue = Math.ceil(Number(this.saleFieldTarget.value))

    const commValue = Math.ceil(saleValue * 0.25)

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0
    this.nettFieldTarget.value = saleValue - commValue

    this.updatePercentage()
  }

  calculateTenPercentToCompanyTenPercentToAgent() {
    const saleValue = Math.ceil(Number(this.saleFieldTarget.value))

    const commValue = Math.ceil(saleValue * 0.1)
    const agentValue = Math.ceil(saleValue * 0.1)

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = agentValue.toFixed(0)
    this.nettFieldTarget.value = saleValue - commValue - agentValue

    this.updatePercentage()
  }

  calculateFifteenPercentToCompanyTenPercentToAgent() {
    const saleValue = Math.ceil(Number(this.saleFieldTarget.value))

    const commValue = Math.ceil(saleValue * 0.15)
    const agentValue = Math.ceil(saleValue * 0.1)

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = agentValue.toFixed(0)
    this.nettFieldTarget.value = saleValue - commValue - agentValue

    this.updatePercentage()
  }
}
