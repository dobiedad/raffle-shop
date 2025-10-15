import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="raffle-preview"
export default class extends Controller {
  static targets = [
    "name",
    "ticketPrice",
    "description",
    "image"
  ]

  connect() {
    this.updatePreview()
  }

  updateName() {
    const name = this.nameTarget.value || "Sample Raffle"
    const previewCard = document.querySelector("#preview-card")
    const titleElement = previewCard.querySelector(".title")
    if (titleElement) {
      titleElement.textContent = name
    }
  }

  updateTicketPrice() {
    const price = this.ticketPriceTarget.value || "3.50"
    const formattedPrice = parseFloat(price).toFixed(2)
    const previewCard = document.querySelector("#preview-card")
    const subtitleElement = previewCard.querySelector(".subtitle")
    if (subtitleElement) {
      subtitleElement.textContent = `$${formattedPrice} per ticket`
    }
  }

  updateDescription() {
    const description = this.getDescriptionText() || "Add a description to see it here..."
    const truncated = this.truncate(description, 100)
    const previewCard = document.querySelector("#preview-card")
    const contentElement = previewCard.querySelector(".card-content .content")
    if (contentElement) {
      contentElement.textContent = truncated
    }
  }

  updateImage(event) {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        const previewCard = document.querySelector("#preview-card")
        const imageElement = previewCard.querySelector(".card-image img")
        if (imageElement) {
          imageElement.src = e.target.result
        }
      }
      reader.readAsDataURL(file)
    }
  }

  updatePreview() {
    this.updateName()
    this.updateTicketPrice()
    this.updateDescription()
  }

  getDescriptionText() {
    // Try to get the trix editor content
    const trixEditor = this.element.querySelector('trix-editor')
    if (trixEditor) {
      return trixEditor.textContent.trim()
    }
    return ""
  }

  truncate(str, length) {
    if (str.length <= length) return str
    return str.substring(0, length) + "..."
  }
}

