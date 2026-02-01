import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    // フォームを自動送信
    this.element.requestSubmit()
  }
}
