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
    this.saleInput = document.querySelector('input[name="booking[sale]"]');
    this.agentInput = document.querySelector('input[name="booking\\[agent\\]"]');
    this.nettInput = document.querySelector('input[name="booking\\[nett\\]"]');
    this.commInput = document.querySelector('input[name="booking\\[comm\\]"]');
    this.startInput = document.querySelector('input[name="booking[start]"]');
    this.finishInput = document.querySelector('input[name="booking[finish]"]');
    this.houseSelect = document.querySelector('select[name="booking[house_id]"]');

    // Обработчики событий для полей формы
    this.startInput.addEventListener('change', () => this.handleFormChange());
    this.finishInput.addEventListener('change', () => this.handleFormChange());
    this.houseSelect.addEventListener('change', () => this.handleFormChange());


    this.saleInput.addEventListener('input', (event) => {
      if (this.saleInput.value < 0) {
        event.target.value = 0;
      }

      this.targets.find("nettPercentage").textContent = (parseInt(this.nettInput.value) / parseInt(this.saleInput.value)) * 100 + '%';

      if (parseInt(this.saleInput.value) < (parseInt(this.agentInput.value) + parseInt(this.commInput.value))) {
        this.nettInput.value = this.saleInput.value;
        this.agentInput.value = 0;
        this.commInput.value = 0;
        this.targets.find("agentPercentage").textContent = "0%";
        this.targets.find("commPercentage").textContent = "0%";
        this.updatePercentage();
      }
    });

    this.saleInput.value = 0;

    this.agentInput.addEventListener('input', (event) => {
      if (this.agentInput.value < 0) {
        event.target.value = 0;
      }

      const newAgentValue = parseInt(event.target.value);
      let summValue = newAgentValue + parseInt(this.commInput.value) + parseInt(this.nettInput.value);

      if (this.saleInput.value < summValue) {
        event.target.value = this.previousAgentValue;
        this.nettInput.value = parseInt(this.saleInput.value) - parseInt((this.commInput.value));
        this.targets.find("agentPercentage").textContent = '0%';
        this.agentInput.value = 0;
        this.targets.find("nettPercentage").textContent = Math.round((parseInt(this.nettInput.value) / parseInt(this.saleInput.value)) * 100) + '%';
      } else {
        event.target.value = newAgentValue;
      }
    });

    this.commInput.addEventListener('input', (event) => {
      if (this.commInput.value < 0) {
        event.target.value = 0;
      }

      const newCommValue = parseInt(event.target.value);
      let summValue = newCommValue + parseInt(this.agentInput.value) + parseInt(this.nettInput.value);

      if (this.saleInput.value < summValue) {
        event.target.value = this.previousCommValue;
        this.nettInput.value = parseInt(this.saleInput.value) - parseInt((this.agentInput.value));
        this.targets.find("commPercentage").textContent = '0%';
        this.commInput.value = 0;
        this.targets.find("nettPercentage").textContent = Math.round((parseInt(this.nettInput.value) / parseInt(this.saleInput.value)) * 100) + '%';
      } else {
        event.target.value = newCommValue;
      }
    });

    this.startTimer();
    this.updatePercentage();
  }

  calculateTenPercentToCompanyTenPercentToAgent() {
    const saleValue = parseInt(this.saleInput.value) || 0;

    const commValue = saleValue * 0.1;
    const agentValue = saleValue * 0.1;
    const nettValue = saleValue - commValue - agentValue;

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

    this.commInput.value = commValue.toFixed(0);
    this.agentInput.value = agentValue.toFixed(0);
    this.nettInput.value = nettValue.toFixed(0);

    this.updatePercentage();
  }


  // Функция для пересчета процентов
  recalculatePercentages() {
    let saleValue = parseInt(this.saleInput.value) || 1;
    const agentValue = parseInt(this.agentInput.value) || 0;
    const commValue = parseInt(this.commInput.value) || 0;
    const nettValue = parseInt(this.nettInput.value) || 0;

    const maxNettValue = saleValue - commValue - agentValue;
    this.nettInput.value = Math.min(nettValue, maxNettValue);

    if (this.nettInput.value < 0) {
      this.nettInput.value = 0;
    }

    const bookingAgentPercentage = isNaN(agentValue) ? 0 : Math.min(100, Math.round((agentValue / saleValue) * 100));
    const bookingCommissionPercentage = isNaN(commValue) ? 0 : Math.min(100, Math.round((commValue / saleValue) * 100));
    const bookingNettPercentage = isNaN(nettValue) ? 0 : Math.min(100, Math.round((nettValue / saleValue) * 100));

    this.targets.find("agentPercentage").textContent = bookingAgentPercentage.toFixed(0) + '%';
    this.targets.find("commPercentage").textContent = bookingCommissionPercentage.toFixed(0) + '%';
    this.targets.find("nettPercentage").textContent = bookingNettPercentage.toFixed(0) + '%';
  }


  updatePercentage(agentInput, commInput, nettInput) {
    let saleValue = parseInt(this.saleFieldTarget.value) || 0;
    let agentValue = parseInt(this.agentFieldTarget.value) || 0;
    let commValue = parseInt(this.commFieldTarget.value) || 0;
    let nettValue = parseInt(this.nettFieldTarget.value) || 0;

    if (agentValue === 0 && commValue === 0){
      nettValue = saleValue
    }
    else {
      nettValue = saleValue - agentValue - commValue
    }

    // Nan checking
    saleValue = Math.max(0, saleValue);
    agentValue = Math.max(0, agentValue);
    commValue = Math.max(0, commValue);
    nettValue = Math.max(0, nettValue);

    // We check that the value does not exceed sale - comm - agent
    const maxNettValue = saleValue - commValue - agentValue;
    nettValue = Math.min(maxNettValue, nettValue);

    // We check that the sum of comm, agent and nett does not exceed sale
    const total = commValue + agentValue + nettValue;

    if (nettValue < 0) {
      nettValue = 0
    }

    // If the amount exceeds sale, set the values so that it is equal to sale
    if (total > saleValue) {
      const diff = total - saleValue;
      if (commValue >= diff) {
        commValue = Math.max(0, commValue - diff);
      } else if (agentValue >= diff) {
        agentValue = Math.max(0, agentValue - diff);
      } else {
        nettValue = Math.max(0, nettValue - diff);
      }
    }

    this.maxValue = saleValue - commValue - agentValue;

    // Set values
    this.commFieldTarget.value = commValue.toFixed(0);
    this.agentFieldTarget.value = agentValue.toFixed(0);
    this.nettFieldTarget.value = nettValue.toFixed(0);

    // Calculate interest and update interest bars
    let bookingAgentPercentage = 0;
    let bookingCommissionPercentage = 0;
    let bookingNettPercentage = 0;

    if (!(isNaN(agentValue) || isNaN(commValue) || isNaN(saleValue))) {
      bookingAgentPercentage = Math.min(100, Math.round((agentValue / saleValue) * 100));
      bookingCommissionPercentage = Math.min(100, Math.round((commValue / saleValue) * 100));
      bookingNettPercentage = Math.min(100, Math.round((nettValue / saleValue) * 100));
    }


    // Setting percentages in text format
    if (!(isNaN(bookingAgentPercentage) || isNaN(bookingCommissionPercentage) || isNaN(bookingNettPercentage))) {
      this.targets.find("agentPercentage").textContent = bookingAgentPercentage.toFixed(0) + '%';
      this.targets.find("commPercentage").textContent = bookingCommissionPercentage.toFixed(0) + '%';
      this.targets.find("nettPercentage").textContent = bookingNettPercentage.toFixed(0) + '%';
    }
    else {
      bookingAgentPercentage = 0;
      bookingCommissionPercentage = 0;
      bookingNettPercentage = 0;
      this.targets.find("agentPercentage").textContent = '0%';
      this.targets.find("commPercentage").textContent = '0%';
      this.targets.find("nettPercentage").textContent = '0%';
    }

    if (bookingAgentPercentage === 0 && bookingCommissionPercentage === 0){
      bookingNettPercentage = 100
      nettInput.value = saleInput.value
      this.targets.find("nettPercentage").textContent = bookingNettPercentage.toFixed(0) + '%';
    }
  }

  handleFormChange() {
    // Enable/disable the timer based on the selection of values
    const selectedStartDate = this.startInput.value;
    const selectedFinishDate = this.finishInput.value;
    const selectedHouseId = this.houseSelect.value;

    if (selectedStartDate && selectedFinishDate && selectedHouseId) {
      this.startTimer();
    } else {
      this.stopTimer();
    }
  }

  startTimer() {
    this.stopTimer(); // Stop the timer if it is already running

    this.timerInterval = setInterval(() => {
      // Calling the function to recalculate percentages
      this.recalculatePercentages();
    }, 100);
  }

  stopTimer() {
    // Stop the timer if it is running
    if (this.timerInterval) {
      clearInterval(this.timerInterval);
      this.timerInterval = null;
    }
  }
}
