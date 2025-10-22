import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    text: String
  }

  connect() {
    if (!('share' in navigator)) {
      this.element.style.display = 'none'
    }
  }

  share(event) {
    event.preventDefault()
    
    if ('share' in navigator) {
      navigator.share({
        title: 'Raffle Shop',
        text: this.textValue,
        url: this.urlValue
      }).catch(() => {})
    }
  }
}

