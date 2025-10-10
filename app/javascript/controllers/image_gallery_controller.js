import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mainImage", "thumbnail", "currentIndex"]

  connect() {
    this.currentImageIndex = 0
    this.totalImages = this.thumbnailTargets.length
    
    // Set first thumbnail as active on load
    if (this.hasThumbnailTarget) {
      const firstWrapper = this.thumbnailTargets[0].closest('.thumbnail-item')
      if (firstWrapper) {
        firstWrapper.classList.add('active')
      }
    }
  }

  changeImage(event) {
    const clickedThumbnail = event.currentTarget
    const imageUrl = clickedThumbnail.dataset.imageUrl
    const index = parseInt(clickedThumbnail.dataset.index)
    
    this.showImage(index)
  }

  previousImage(event) {
    event.preventDefault()
    this.currentImageIndex = (this.currentImageIndex - 1 + this.totalImages) % this.totalImages
    this.showImage(this.currentImageIndex)
  }

  nextImage(event) {
    event.preventDefault()
    this.currentImageIndex = (this.currentImageIndex + 1) % this.totalImages
    this.showImage(this.currentImageIndex)
  }

  showImage(index) {
    this.currentImageIndex = index
    
    // Get the thumbnail at this index
    const thumbnail = this.thumbnailTargets[index]
    const imageUrl = thumbnail.dataset.imageUrl
    
    // Update main image
    this.mainImageTarget.src = imageUrl
    
    // Update image counter
    if (this.hasCurrentIndexTarget) {
      this.currentIndexTarget.textContent = index + 1
    }
    
    // Update active thumbnail styling
    this.thumbnailTargets.forEach((thumb, i) => {
      const wrapper = thumb.closest('.thumbnail-item')
      if (i === index) {
        wrapper.classList.add('active')
      } else {
        wrapper.classList.remove('active')
      }
    })
  }
}

