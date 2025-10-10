import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropzone", "input", "previews"]

  connect() {
    this.filesList = []
  }

  openFileDialog(event) {
    if (event.target === this.inputTarget) return
    event.preventDefault()
    this.inputTarget.click()
  }

  dragOver(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add('drag-over')
  }

  dragLeave(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove('drag-over')
  }

  drop(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove('drag-over')
    
    const files = Array.from(event.dataTransfer.files)
    const imageFiles = files.filter(file => file.type.startsWith('image/'))
    
    this.addFiles(imageFiles)
  }

  handleFiles(event) {
    const files = Array.from(event.target.files)
    this.addFiles(files)
  }

  addFiles(files) {
    // Limit to 10 images total
    const remainingSlots = 10 - this.filesList.length
    const filesToAdd = files.slice(0, remainingSlots)
    
    filesToAdd.forEach((file, index) => {
      this.filesList.push(file)
      this.createPreview(file, this.filesList.length - 1)
    })
    
    this.updateFileInput()
  }

  createPreview(file, index) {
    const reader = new FileReader()
    
    reader.onload = (e) => {
      const preview = document.createElement('div')
      preview.className = 'image-preview-item'
      preview.dataset.index = index
      
      preview.innerHTML = `
        <img src="${e.target.result}" alt="Preview">
        <button type="button" class="remove-image" data-action="click->image-upload#removeImage" data-index="${index}">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      `
      
      this.previewsTarget.appendChild(preview)
    }
    
    reader.readAsDataURL(file)
  }

  removeImage(event) {
    event.preventDefault()
    const index = parseInt(event.currentTarget.dataset.index)
    
    // Remove from filesList
    this.filesList.splice(index, 1)
    
    // Remove preview element
    const previewItem = this.previewsTarget.querySelector(`[data-index="${index}"]`)
    if (previewItem) {
      previewItem.remove()
    }
    
    // Update remaining indices
    this.previewsTarget.querySelectorAll('.image-preview-item').forEach((item, newIndex) => {
      item.dataset.index = newIndex
      const button = item.querySelector('.remove-image')
      if (button) {
        button.dataset.index = newIndex
      }
    })
    
    this.updateFileInput()
  }

  updateFileInput() {
    // Create a new DataTransfer to update the file input
    const dataTransfer = new DataTransfer()
    
    this.filesList.forEach(file => {
      dataTransfer.items.add(file)
    })
    
    this.inputTarget.files = dataTransfer.files
  }
}
