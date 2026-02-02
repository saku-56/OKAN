import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dateField", "editBtn", "saveBtn"]

  connect() {
    this.originalValue = this.dateFieldTarget.value
  }

  // 編集アイコンクリック
  edit() {
    this.dateFieldTarget.disabled = false
    this.dateFieldTarget.focus()
    this.editBtnTarget.classList.add("hidden")
  }

  // 日付が変更された
  dateChanged() {
    const value = this.dateFieldTarget.value
    if (value) {
      this.saveBtnTarget.classList.remove("hidden")
    }
  }

  // 保存ボタンクリック
  save() {
    const value = this.dateFieldTarget.value
    if (!value) {
      alert("日付を選択してください")
      return
    }

    // 確認ダイアログなしで直接送信
    this.element.requestSubmit()
  }
}