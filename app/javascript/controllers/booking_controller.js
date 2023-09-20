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
    "commPercentage",
    "nettPercentage"
  ]

  connect() {
    this.saleInput = document.querySelector('input[name="booking[sale]"]');
    this.agentInput = document.querySelector('input[name="booking\\[agent\\]"]');
    this.nettInput = document.querySelector('input[name="booking\\[nett\\]"]');
    this.commInput = document.querySelector('input[name="booking\\[comm\\]"]');
    this.startInput = document.querySelector('input[name="booking[start]"]');
    this.finishInput = document.querySelector('input[name="booking[finish]"]');
    this.houseSelect = document.querySelector('select[name="booking[house_id]"]');

    this.saleFieldTarget.value = 0
    this.agentFieldTarget.value = 0
    this.commFieldTarget.value = 0
    this.nettFieldTarget.value = 0

    this.startTimer();
    this.updatePercentage()

    this.saleInput.addEventListener('input', () => {
      const saleValue = parseFloat(this.saleInput.value) || 0;
      if (saleValue < 0) {
        this.saleInput.value = '0';
        this.updatePercentage();
      }
    });

    this.commInput.addEventListener('input', () => {
      const commValue = parseFloat(this.commInput.value) || 0;
      if (commValue < 0) {
        this.commInput.value = '0';
        this.updatePercentage();
      }
    });

    this.agentInput.addEventListener('input', () => {
      const agentValue = parseFloat(this.agentInput.value) || 0;
      if (agentValue < 0) {
        this.agentInput.value = '0';
        this.updatePercentage();
      }
    });

    this.nettInput.addEventListener('input', () => {
      const nettValue = parseFloat(this.nettInput.value) || 0;
      if (nettValue < 0) {
        this.nettInput.value = '0';
        this.updatePercentage();
      }
    });

    this.saleFieldTarget.addEventListener('input', () => {
      this.updatePercentage();
      this.checkingValues();
    });

    this.agentFieldTarget.addEventListener('input', () => {
      this.updatePercentage();
      this.checkingValues();
    });

    this.commFieldTarget.addEventListener('input', () => {
      this.updatePercentage();
      this.checkingValues();
    });

    this.nettFieldTarget.addEventListener('input', () => {
      this.updatePercentage();
      this.checkingValues();
    });
  }

  checkingValues() {
    const saleValue = parseFloat(this.saleFieldTarget.value) || 0;
    const agentValue = parseFloat(this.agentFieldTarget.value) || 0;
    const commValue = parseFloat(this.commFieldTarget.value) || 0;
    const nettValue = parseFloat(this.nettFieldTarget.value) || 0;

    if(saleValue === (agentValue + commValue + nettValue)) {
      if ((this.agentPercentageTarget.classList.contains('bg-danger') &&
          this.commPercentageTarget.classList.contains('bg-danger') &&
          this.nettPercentageTarget.classList.contains('bg-danger'))) {

        this.agentPercentageTarget.classList.remove('bg-danger');
        this.commPercentageTarget.classList.remove('bg-danger');
        this.nettPercentageTarget.classList.remove('bg-danger');
      }
    }
    else {
      if (!(this.agentPercentageTarget.classList.contains('bg-danger') &&
          this.commPercentageTarget.classList.contains('bg-danger') &&
          this.nettPercentageTarget.classList.contains('bg-danger'))) {

        this.agentPercentageTarget.classList.add('bg-danger');
        this.commPercentageTarget.classList.add('bg-danger');
        this.nettPercentageTarget.classList.add('bg-danger');
      }
    }
  }

  updatePercentage() {
    const saleValue = parseFloat(this.saleFieldTarget.value) || 1;
    let agentValue = parseFloat(this.agentFieldTarget.value) || 0;
    const commValue = parseFloat(this.commFieldTarget.value) || 0;
    const nettValue = parseFloat(this.nettFieldTarget.value) || 0;

    let bookingAgentPercentage = Math.max(0, (agentValue / (nettValue + commValue + agentValue)) * 100) || 0;
    let bookingCommissionPercentage = Math.max(0, (commValue / (nettValue + commValue + agentValue)) * 100) || 0;
    let bookingNettPercentage = Math.max(0, (nettValue / (nettValue + commValue + agentValue)) * 100) || 0;

    this.agentPercentageTarget.textContent = bookingAgentPercentage.toFixed(0) + '%';
    this.commPercentageTarget.textContent = bookingCommissionPercentage.toFixed(0) + '%'
    this.nettPercentageTarget.textContent = bookingNettPercentage.toFixed(0) + '%';
  }

  recalculatePercentages() {
    let saleValue = parseInt(this.saleInput.value) || 1;
    const agentValue = parseInt(this.agentInput.value) || 0;
    const commValue = parseInt(this.commInput.value) || 0;
    const nettValue = parseInt(this.nettInput.value) || 0;

    if (this.nettInput.value < 0) {
      this.nettInput.value = 0;
    }

    let bookingAgentPercentage = Math.max(0, ((agentValue / (nettValue + commValue + agentValue)) * 100)) || 0;
    let bookingCommissionPercentage = Math.max(0, (commValue / (nettValue + commValue + agentValue)) * 100) || 0;
    let bookingNettPercentage = Math.max(0, (nettValue / (nettValue + commValue + agentValue)) * 100) || 0;

    this.targets.find("agentPercentage").textContent = bookingAgentPercentage.toFixed(0) + '%';
    this.targets.find("commPercentage").textContent = bookingCommissionPercentage.toFixed(0) + '%';
    this.targets.find("nettPercentage").textContent = bookingNettPercentage.toFixed(0) + '%';
  }

  startTimer() {
    this.stopTimer();

    this.timerInterval = setInterval(() => {
      this.recalculatePercentages();
      this.checkingValues();
    }, 1);
  }

  stopTimer() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval);
      this.timerInterval = null;
      this.recalculatePercentages();
      this.updatePercentage();
    }
  }

  calculateTwentyPercent() {
    const saleValue = parseInt(this.saleInput.value) || 0;
    const commValue = saleValue * 0.2;
    const agentValue = 0;
    const nettValue = saleValue - commValue - agentValue;

    if (saleValue < agentValue + commValue + nettValue) {
      return;
    }

    this.commInput.value = commValue.toFixed(0);
    this.agentInput.value = agentValue.toFixed(0);
    this.nettInput.value = nettValue.toFixed(0);

    this.updatePercentage();
  }

  calculateTwentyFivePercent() {
    const saleValue = parseInt(this.saleInput.value) || 0;
    const commValue = saleValue * 0.25;
    const agentValue = 0;
    const nettValue = saleValue - commValue - agentValue;

    if (saleValue < agentValue + commValue + nettValue) {
      return;
    }

    this.commInput.value = commValue.toFixed(0);
    this.agentInput.value = agentValue.toFixed(0);
    this.nettInput.value = nettValue.toFixed(0);

    this.updatePercentage();
  }

  calculateTenPercentToCompanyTenPercentToAgent() {
    const saleValue = parseInt(this.saleInput.value) || 0;

    const commValue = saleValue * 0.1;
    const agentValue = saleValue * 0.1;
    const nettValue = saleValue - commValue - agentValue;

    if (saleValue < agentValue + commValue + nettValue) {
      return;
    }

    this.commInput.value = commValue.toFixed(0);
    this.agentInput.value = agentValue.toFixed(0);
    this.nettInput.value = nettValue.toFixed(0);

    this.updatePercentage();
  }

  calculateFifteenPercentToCompanyTenPercentToAgent() {
    const saleValue = parseInt(this.saleInput.value) || 0;

    const commValue = saleValue * 0.15;
    const agentValue = saleValue * 0.1;
    const nettValue = saleValue - commValue - agentValue;

    if (saleValue < agentValue + commValue + nettValue) {
      return;
    }

    this.commInput.value = commValue.toFixed(0);
    this.agentInput.value = agentValue.toFixed(0);
    this.nettInput.value = nettValue.toFixed(0);

    this.updatePercentage();
  }
}