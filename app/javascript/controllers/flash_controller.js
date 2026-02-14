import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // 3秒後にフェードアウトして削除
    setTimeout(() => {
      this.element.style.transition = "opacity 0.5s ease-out"
      this.element.style.opacity = "0"

      // フェードアウトが完了したら要素を削除
      setTimeout(() => {
        this.element.remove()
      }, 500)
    }, 3000)
  }
}