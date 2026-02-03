import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dateField", "editBtn", "saveBtn", "cancelBtn", "errorMessage"]

  connect() {
    this.originalValue = this.dateFieldTarget.value
  }

  // 編集アイコンクリック
  edit() {
    this.dateFieldTarget.disabled = false
    this.dateFieldTarget.focus()

    // 編集アイコンを非表示
    this.editBtnTarget.classList.add("hidden")

    // キャンセルボタンを表示（追加）
    this.cancelBtnTarget.classList.remove("hidden")

    this.hideError()
  }

  // 日付が変更された
  dateChanged() {
    const value = this.dateFieldTarget.value

    // エラーをクリア
    this.hideError()

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

    // 日付未選択チェック
    if (!value) {
      this.showError("日付を選択してください")
      return
    }

    // 過去の日付チェック
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    const selected = new Date(value)

    if (selected < today) {
      this.showError("過去の日付は選択できません")
      return
    }

    // バリデーションOKなら送信
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

    // エラーメッセージを非表示
    this.hideError()
  }

  // エラーメッセージを表示（5秒間表示）
  showError(message) {
    if (this.hasErrorMessageTarget) {
      this.errorMessageTarget.textContent = message
      this.errorMessageTarget.classList.remove("hidden")

      // 既存のタイマーをクリア
      if (this.errorTimer) {
        clearTimeout(this.errorTimer)
      }

      // 5秒後に自動で非表示
      this.errorTimer = setTimeout(() => {
        this.hideError()
      }, 5000)
    }
  }

  // エラーメッセージを非表示
  hideError() {
    if (this.hasErrorMessageTarget) {
      this.errorMessageTarget.classList.add("hidden")

      // タイマーをクリア
      if (this.errorTimer) {
        clearTimeout(this.errorTimer)
        this.errorTimer = null
      }
    }
  }

  // コントローラーが破棄される時にタイマーをクリア
  disconnect() {
    if (this.errorTimer) {
      clearTimeout(this.errorTimer)
    }
  }
}
