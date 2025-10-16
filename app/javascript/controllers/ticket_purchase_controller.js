import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["quantity", "total"]

  connect() {
    this.ticketPrice = parseFloat(this.element.dataset.ticketPrice) || 0
    this.updateTotal()
  }

  updateTotal() {
    const quantity = parseInt(this.quantityTarget.value) || 1
    const total = (this.ticketPrice * quantity).toFixed(2)
    this.totalTarget.textContent = `$${total}`
  }
}

