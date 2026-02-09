import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification-toggle"
export default class extends Controller {
  static targets = ["checkbox", "selectBox", "container"]

  connect() {
    // 初期状態の設定
    this.toggleFields()
  }

  toggleFields() {
    if (this.checkboxTarget.checked) {
      // チェックが入っている場合:有効化
      this.selectBoxTarget.disabled = false
      this.containerTarget.classList.remove("opacity-50", "pointer-events-none")
      this.selectBoxTarget.classList.remove("cursor-not-allowed")
    } else {
      // チェックが外れている場合:無効化
      this.selectBoxTarget.disabled = true
      this.containerTarget.classList.add("opacity-50", "pointer-events-none")
      this.selectBoxTarget.classList.add("cursor-not-allowed")
    }
  }
}