import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hospitalLink", "medicineLink"]

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

  // 在庫切れをクリックしたときの処理
  visitMedicine(event) {
    event.preventDefault()
    event.stopPropagation()

    const medicinePath = event.currentTarget.dataset.medicinePath

    if (medicinePath) {
      Turbo.visit(medicinePath)
    }
  }
}
