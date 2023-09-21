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

  connect() {
    this.saleInput = this.saleFieldTarget;
    this.agentInput = this.agentFieldTarget;
    this.commInput = this.commFieldTarget;
    this.nettInput = this.nettFieldTarget;
    // Устанавливаем начальные значения
    this.saleFieldTarget.value = 0;
    this.agentFieldTarget.value = 0;
    this.commFieldTarget.value = 0;
    this.nettFieldTarget.value = 0;

    this.updatePercentage();
  }

  inputChanged(event) {
    let inputValue = parseFloat(event.target.value) || 0;
    event.target.value = inputValue.toFixed(0);
    this.updatePercentage();
  }

  checkingValues() {
    const saleValue = parseFloat(this.saleFieldTarget.value) || 0;
    const agentValue = parseFloat(this.agentFieldTarget.value) || 0;
    const commValue = parseFloat(this.commFieldTarget.value) || 0;
    const nettValue = parseFloat(this.nettFieldTarget.value) || 0;

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

  updatePercentage() {
    let saleValue = parseFloat(this.saleFieldTarget.value) || 0;
    let agentValue = parseFloat(this.agentFieldTarget.value) || 0;
    let commValue = parseFloat(this.commFieldTarget.value) || 0;
    let nettValue = parseFloat(this.nettFieldTarget.value) || 0;

    this.checkingValues();

    let totalValue = saleValue;

    let bookingAgentPercentage = 0;
    let bookingCommissionPercentage = 0;
    let bookingNettPercentage = 0;

    if (saleValue === 0) {
      totalValue = 1
    }

    // Ensure percentages are not negative
    bookingAgentPercentage = Math.max(0, (agentValue / totalValue) * 100);
    bookingCommissionPercentage = Math.max(0, (commValue / totalValue) * 100);
    bookingNettPercentage = Math.max(0, (nettValue / totalValue) * 100);


    this.agentFieldTarget.value = agentValue.toFixed(0);
    this.commFieldTarget.value = commValue.toFixed(0);
    this.nettFieldTarget.value = nettValue.toFixed(0);

    this.agentPercentageTarget.textContent = bookingAgentPercentage.toFixed(0) + '%';
    this.commPercentageTarget.textContent = bookingCommissionPercentage.toFixed(0) + '%';
    this.nettPercentageTarget.textContent = bookingNettPercentage.toFixed(0) + '%';
  }

  recalculatePercentages() {
    const saleValue = parseInt(this.saleFieldTarget.value) || 1;
    const agentValue = parseInt(this.agentFieldTarget.value) || 0;
    const commValue = parseInt(this.commFieldTarget.value) || 0;
    const nettValue = parseInt(this.nettFieldTarget.value) || 0;

    if (this.nettFieldTarget.value < 0) {
      this.nettFieldTarget.value = 0;
    }

    this.updatePercentage();
  }

  calculateTwentyPercent() {
    const saleValue = Number(this.saleFieldTarget.value)

    const commValue = saleValue * 0.2

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0
    this.nettFieldTarget.value = saleValue - commValue

    this.updatePercentage()
  }

  calculateTwentyFivePercent() {
    const saleValue = Number(this.saleFieldTarget.value)

    const commValue = saleValue * 0.25

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0
    this.nettFieldTarget.value = saleValue - commValue

    this.updatePercentage()
  }

  calculateTenPercentToCompanyTenPercentToAgent() {
    const saleValue = Number(this.saleFieldTarget.value)

    const commValue = saleValue * 0.1
    const agentValue = saleValue * 0.1

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = agentValue.toFixed(0)
    this.nettFieldTarget.value = saleValue - commValue - agentValue

    this.updatePercentage()
  }

  calculateFifteenPercentToCompanyTenPercentToAgent() {
    const saleValue = Number(this.saleFieldTarget.value)

    const commValue = saleValue * 0.15
    const agentValue = saleValue * 0.1

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = agentValue.toFixed(0)
    this.nettFieldTarget.value = saleValue - commValue - agentValue

    this.updatePercentage()
  }
}
