import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="raffle-preview"
export default class extends Controller {
  static targets = [
    "name",
    "ticketPrice",
    "description"
  ]

  connect() {
    this.updatePreview()
    this.defaultImageUrl = 'https://community.softr.io/uploads/db9110/original/2X/7/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a6.jpeg'
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
    // Updated selector for new card design
    const priceElement = previewCard.querySelector(".has-text-weight-semibold")
    if (priceElement) {
      priceElement.textContent = `$${formattedPrice} per ticket`
    }
  }

  updateDescription() {
    const description = this.getDescriptionText() || "Add a description to see it here..."
    // Updated truncation to match component (80 chars)
    const truncated = this.truncate(description, 80)
    const previewCard = document.querySelector("#preview-card")
    // Updated selector for new card design
    const descriptionElement = previewCard.querySelector(".is-size-7.has-text-grey.mb-4")
    if (descriptionElement) {
      descriptionElement.textContent = truncated
    }
  }

  // Listen for images changed event from image-upload controller
  handleImagesChanged(event) {
    const files = event.detail.files
    const previewCard = document.querySelector("#preview-card")
    const imageElement = previewCard.querySelector(".card-image img")
    
    if (!imageElement) return

    if (files && files.length > 0) {
      // Show the first image in the list
      const firstFile = files[0]
      const reader = new FileReader()
      reader.onload = (e) => {
        imageElement.src = e.target.result
      }
      reader.readAsDataURL(firstFile)
    } else {
      // No images, show placeholder
      imageElement.src = this.defaultImageUrl
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
