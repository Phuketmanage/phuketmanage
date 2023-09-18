import { Controller } from "@hotwired/stimulus"

function fetchData() {
  fetch('/bookings/get_price')
      .then(response => {
        if (!response.ok) {
          console.log(response)
          throw new Error('Network response was not ok');
        }
        return response.json(); // возвращает promise с распарсенным JSON
      })
      .then(data => {
        console.log('Данные из файла JSON:', data);
      })
      .catch(error => console.error('Произошла ошибка:', error));
}

// Вызывайте функцию для загрузки данных
const intervalId = setInterval(fetchData, 5000);

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
    const saleInput = document.getElementById('saleInput');
    const agentInput = document.getElementById('agentInput');
    const nettInput = document.getElementById('nettInput');
    const commInput = document.getElementById('commInput');

    let previousSaleValue = parseInt(saleInput.value) || 0;
    let previousAgentValue = parseInt(agentInput.value) || 0;
    let previousCommValue = parseInt(commInput.value) || 0;

    saleInput.addEventListener('input', (event) => {
      if (saleInput.value < 0) {
        event.target.value = 0;
      }

      if (saleInput.value < (parseInt(agentInput.value) + parseInt(commInput.value))) {
        nettInput.value = saleInput.value
        agentInput.value = 0;
        commInput.value = 0;
        this.targets.find("agentPercentage").textContent = "0%"
        this.targets.find("commPercentage").textContent = "0%"
        this.updatePercentage(agentInput, commInput, nettInput)
      }
    });

    saleInput.value = 0

    agentInput.addEventListener('input', (event) => {
      const newAgentValue = parseInt(event.target.value);
      let summValue = newAgentValue + parseInt(commInput.value) + parseInt(nettInput.value)

      if (saleInput.value < summValue) {
        event.target.value = previousAgentValue;
        nettInput.value =  parseInt(saleInput.value) - parseInt((commInput.value));
        this.targets.find("agentPercentage").textContent =  '0%';
        agentInput.value = 0;
        this.targets.find("nettPercentage").textContent = Math.round((parseInt(nettInput.value) / parseInt(saleInput.value)) * 100) + '%';
      }
      else {
        event.target.value = newAgentValue
      }
    });

    commInput.addEventListener('input', (event) => {
      const newCommValue = parseInt(event.target.value);
      let summValue = newCommValue + parseInt(agentInput.value) + parseInt(nettInput.value)

      if (saleInput.value < summValue) {
        event.target.value = previousCommValue;
        nettInput.value =  parseInt(saleInput.value) - parseInt((agentInput.value))
        this.targets.find("commPercentage").textContent =  '0%';
        commInput.value = 0;
        this.targets.find("nettPercentage").textContent = Math.round((parseInt(nettInput.value) / parseInt(saleInput.value)) * 100) + '%';
      }
      else {
        event.target.value = newCommValue
      }
    });

    this.updatePercentage(agentInput, commInput, nettInput)
    this.targets.find("nettPercentage").textContent = "0%";
  }

  //15% to company 10% to agent
  calculateFifteenPercentToCompanyTenPercentToAgent() {
    const saleValue = parseInt(this.saleFieldTarget.value)

    const commValue = saleValue * 0.15
    const agentValue= saleValue * 0.1
    const nettValue = saleValue - commValue - agentValue

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = agentValue.toFixed(0)
    this.nettFieldTarget.value = nettValue.toFixed(0)

    this.updatePercentage()
  }
 //10% to company 10% to agent
  calculateTenPercentToCompanyTenPercentToAgent() {
    const saleValue = parseInt(this.saleFieldTarget.value)

    const commValue = saleValue * 0.1
    const agentValue = saleValue * 0.1
    const nettValue = saleValue - commValue - agentValue

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = agentValue.toFixed(0)
    this.nettFieldTarget.value = nettValue.toFixed(0)

    this.updatePercentage()
  }

  //20% to company
  calculateTwentyPercent() {
    const saleValue = parseInt(this.saleFieldTarget.value)

    const commValue = saleValue * 0.2
    const agentValue = 0
    const nettValue = saleValue - commValue - agentValue

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0

    this.nettFieldTarget.value = nettValue.toFixed(0)

    this.updatePercentage()
  }

  //10% to company
  calculateTenPercent() {
    const saleValue = Number(this.saleFieldTarget.value)

    const commValue = saleValue * 0.1
    const agentValue= 0

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0

    const nettValue = saleValue - commValue - agentValue

    this.commFieldTarget.value = commValue.toFixed(0)

    this.nettFieldTarget.value = nettValue.toFixed(0)

    this.updatePercentage()
  }

  //25% to company
  calculateTwentyFivePercent() {
    const saleValue = Number(this.saleFieldTarget.value)

    const commValue = saleValue * 0.25
    const agentValue = 0

    this.commFieldTarget.value = commValue.toFixed(0)
    this.agentFieldTarget.value = 0

    const nettValue = saleValue - commValue - agentValue

    this.commFieldTarget.value = commValue.toFixed(0)

    this.nettFieldTarget.value = nettValue.toFixed(0)

    this.updatePercentage()
  }

  calculateFiftyFifty() {
    const commValue = Number(this.commFieldTarget.value)

    const halfValue = commValue * 0.5

    this.agentFieldTarget.value = halfValue.toFixed(0)

    this.updatePercentage()
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
}