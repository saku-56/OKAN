import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["alert"]

  show(event) {
  if (!this.canMoveForward) {
    event.preventDefault()
    this.alertTarget.classList.remove("hidden")
    return
  }
}
}
