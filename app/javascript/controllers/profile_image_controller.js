import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "input", "image", "overlay"]

  connect() {
    this.setupEventListeners()
  }

  setupEventListeners() {
    if (this.hasContainerTarget && this.hasInputTarget) {
      this.containerTarget.addEventListener('click', () => {
        this.inputTarget.click()
      })

      this.containerTarget.addEventListener('mouseenter', () => {
        this.showOverlay()
      })

      this.containerTarget.addEventListener('mouseleave', () => {
        this.hideOverlay()
      })

      this.inputTarget.addEventListener('change', (e) => {
        this.handleFile(e.target.files[0])
      })
    }
  }

  showOverlay() {
    if (this.hasOverlayTarget) {
      this.overlayTarget.style.display = 'flex'
    }
  }

  hideOverlay() {
    if (this.hasOverlayTarget) {
      this.overlayTarget.style.display = 'none'
    }
  }

  handleFile(file) {
    if (!file || !this.hasImageTarget) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.imageTarget.src = e.target.result
    }
    reader.readAsDataURL(file)
  }
}
