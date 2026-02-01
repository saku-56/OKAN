import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dateField"]
  static values = {
    isNew: Boolean  // 新規登録かどうかを判定
  }

  submit(event) {
    const dateField = event.target
    const selectedDate = dateField.value

    // 日付が選択されていない場合は何もしない
    if (!selectedDate) {
      return
    }

    // 日付を見やすい形式にフォーマット
    const formattedDate = this.formatDate(selectedDate)

    // 確認メッセージを作成（日付を含める）
    const message = this.isNewValue
      ? `${formattedDate} に登録しますか？`
      : `${formattedDate} に変更しますか？`

    // 確認ダイアログを表示
    if (confirm(message)) {
      // OKが押されたらフォームを送信
      this.element.requestSubmit()
    } else {
      // キャンセルが押されたら元の値に戻す
      event.target.value = this.originalValue
    }
  }

  // 日付をフォーマットする関数
  formatDate(dateString) {
    const date = new Date(dateString)

    // 日本語形式でフォーマット（例: 2024年12月15日）
    return date.toLocaleDateString('ja-JP', {
      month: 'long',
      day: 'numeric'
    })
  }

  connect() {
    // 元の値を保存（キャンセル時に戻すため）
    const dateField = this.element.querySelector('input[type="date"]')
    if (dateField) {
      this.originalValue = dateField.value
    }
  }

  // 日付フィールドがフォーカスを得たときに元の値を保存
  savePreviousValue(event) {
    this.originalValue = event.target.value
  }
}