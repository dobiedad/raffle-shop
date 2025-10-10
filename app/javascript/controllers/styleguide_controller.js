import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "toggle"]

  connect() {
    // Start with sidebar open by default
    this.sidebarTarget.classList.remove('is-collapsed')
    this.toggleTarget.classList.remove('is-floating')
  }

  toggleSidebar() {
    this.sidebarTarget.classList.toggle('is-collapsed')
    this.toggleTarget.classList.toggle('is-floating')
  }
}
