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
    let saleValue = parseFloat(this.saleFieldTarget.value);
    let agentValue = parseFloat(this.agentFieldTarget.value);
    let commValue = parseFloat(this.commFieldTarget.value);
    let nettValue = parseFloat(this.nettFieldTarget.value);

    if (saleValue < 0 || agentValue < 0 || commValue < 0 || nettValue < 0 || saleValue === 0 || isNaN(saleValue)) {
      this.agentPercentageTarget.textContent = '-';
      this.commPercentageTarget.textContent = '-';
      this.nettPercentageTarget.textContent = '-';
      this.agentPercentageTarget.classList.add('bg-danger');
      this.commPercentageTarget.classList.add('bg-danger');
      this.nettPercentageTarget.classList.add('bg-danger');
    } else {

      if (isNaN(agentValue) || isNaN(commValue) || isNaN(nettValue)) {
        this.agentPercentageTarget.textContent = '-';
        this.commPercentageTarget.textContent = '-';
        this.nettPercentageTarget.textContent = '-';
        this.agentPercentageTarget.classList.add('bg-danger');
        this.commPercentageTarget.classList.add('bg-danger');
        this.nettPercentageTarget.classList.add('bg-danger');
        return;
      }

      let bookingAgentPercentage = (agentValue / saleValue) * 100;
      let bookingCommissionPercentage = (commValue / saleValue) * 100;
      let bookingNettPercentage = (nettValue / saleValue) * 100;

      this.agentPercentageTarget.textContent = bookingAgentPercentage.toFixed(0) + '%';
      this.commPercentageTarget.textContent = bookingCommissionPercentage.toFixed(0) + '%';
      this.nettPercentageTarget.textContent = bookingNettPercentage.toFixed(0) + '%';

      if (parseFloat(this.saleFieldTarget.value) === (agentValue + commValue + nettValue)) {
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
    const saleValue = parseFloat(this.saleFieldTarget.value)

    const commValue = saleValue * 0.2

    this.commFieldTarget.value = commValue.toFixed(1)
    this.agentFieldTarget.value = 0
    this.nettFieldTarget.value = (saleValue - commValue).toFixed(1)

    this.updatePercentage()
  }

  calculateTwentyFivePercent() {
    const saleValue = parseFloat(this.saleFieldTarget.value)

    const commValue = saleValue * 0.25

    this.commFieldTarget.value = commValue.toFixed(1)
    this.agentFieldTarget.value = 0
    this.nettFieldTarget.value = (saleValue - commValue).toFixed(1)

    this.updatePercentage()
  }

  calculateTenPercentToCompanyTenPercentToAgent() {
    const saleValue = parseFloat(this.saleFieldTarget.value)

    const commValue = saleValue * 0.1
    const agentValue = saleValue * 0.1

    this.commFieldTarget.value = commValue.toFixed(1)
    this.agentFieldTarget.value = agentValue.toFixed(1)
    this.nettFieldTarget.value = (saleValue - commValue - agentValue).toFixed(1)

    this.updatePercentage()
  }

  calculateFifteenPercentToCompanyTenPercentToAgent() {
    const saleValue = parseFloat(this.saleFieldTarget.value)

    const commValue = saleValue * 0.15
    const agentValue = saleValue * 0.1

    this.commFieldTarget.value = commValue.toFixed(1)
    this.agentFieldTarget.value = agentValue.toFixed(1)
    this.nettFieldTarget.value = (saleValue - commValue - agentValue).toFixed(1)

    this.updatePercentage()
  }
}
