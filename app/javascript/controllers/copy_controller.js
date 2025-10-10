import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { text: String }

  copy(event) {
    event.preventDefault()
    
    const button = event.currentTarget
    const originalText = button.textContent
    const originalBg = button.style.backgroundColor
    
    navigator.clipboard.writeText(this.textValue).then(() => {
      button.textContent = "✓ Copied!"
      button.style.color = "#ffffff"
      button.style.backgroundColor = "#4F46E5"
      button.style.borderColor = "#4F46E5"
      
      setTimeout(() => {
        button.textContent = originalText
        button.style.color = ""
        button.style.backgroundColor = originalBg
        button.style.borderColor = ""
      }, 2000)
    }).catch(err => {
      console.error('Failed to copy:', err)
    })
  }
}

