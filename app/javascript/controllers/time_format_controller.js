import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  format(event) {
    let value = event.target.value.replace(/[^0-9]/g, '');

    if (value.length >= 3) {
      // 930 -> 9:30
      const hour = value.slice(0, -2);
      const minute = value.slice(-2);
      value = hour + ':' + minute;
    }

    event.target.value = value;
  }
}