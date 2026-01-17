import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  search() {
    const query = this.inputTarget.value

    if (query.length < 2) {
      this.resultsTarget.innerHTML = ""
      return
    }

    fetch(`/user_medicines/autocomplete?query=${query}`)
      .then(response => response.json())
      .then(data => {
        this.showResults(data)
      })
  }

  showResults(medicines) {
    if (medicines.length === 0) {
      this.resultsTarget.innerHTML = ""
      return
    }

    this.resultsTarget.innerHTML = medicines.map(name =>
      `<div class="p-2 hover:bg-gray-100 cursor-pointer"
            data-action="click->autocomplete#select"
            data-name="${name}">
        ${name}
      </div>`
    ).join("")
  }

  select(event) {
    this.inputTarget.value = event.target.dataset.name
    this.resultsTarget.innerHTML = ""
  }
}