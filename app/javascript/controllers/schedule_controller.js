import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dateField", "editBtn", "saveBtn", "cancelBtn"]

  connect() {
    this.originalValue = this.dateFieldTarget.value
  }

  // 編集アイコンクリック
  edit() {
    this.dateFieldTarget.disabled = false
    this.dateFieldTarget.focus()

    // 編集アイコンを非表示
    this.editBtnTarget.classList.add("hidden")

    // キャンセルボタンを表示
    this.cancelBtnTarget.classList.remove("hidden")
  }

  // 日付が変更された
  dateChanged() {
    const value = this.dateFieldTarget.value

    // 日付が選択されたら保存ボタンを表示
    if (value) {
      this.saveBtnTarget.classList.remove("hidden")
    } else {
      this.saveBtnTarget.classList.add("hidden")
    }

    // キャンセルボタンは常に表示（編集中のため）
    this.cancelBtnTarget.classList.remove("hidden")
  }

  // 保存ボタンクリック
  save() {
    const value = this.dateFieldTarget.value

    // サーバーに送信
    this.element.requestSubmit()
  }

  // キャンセルボタンクリック
  cancel() {
    // 元の値に戻す
    this.dateFieldTarget.value = this.originalValue

    // フィールドを無効化
    this.dateFieldTarget.disabled = true

    // ボタンの表示を切り替え
    this.editBtnTarget.classList.remove("hidden")
    this.saveBtnTarget.classList.add("hidden")
    this.cancelBtnTarget.classList.add("hidden")
  }
}
