import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["hospitalLink"]

  // 通院予定をクリックしたときの処理
  visitHospital(event) {
    event.preventDefault() // デフォルトの動作を停止
    event.stopPropagation() // 親要素（セル全体のリンク）へのイベント伝播を停止

    const hospitalPath = event.currentTarget.dataset.hospitalPath

    if (hospitalPath) {
      // Turboを使って遷移
      Turbo.visit(hospitalPath)
    }
  }
}