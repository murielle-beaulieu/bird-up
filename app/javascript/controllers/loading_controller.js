import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bird", "text", "upload", "uploadTitle"]


  connect() {
    console.log("Loading Connected!");

    // this.birdTarget.classList.remove('d-none')
    // this.textTarget.classList.remove('d-none')

    setTimeout(() => {
      this.uploadTarget.classList.remove('d-none')
    }, 3500);
    setTimeout(() => {
      this.uploadTitleTarget.classList.remove('d-none')
    }, 3500);
    setTimeout(() => {
      this.textTarget.innerText = "Nearly there..."
    }, 7000);
    setTimeout(() => {
      this.textTarget.innerText = "Building results page..."
    }, 14000);
    setTimeout(() => {
      this.textTarget.innerText = "Finding your exact match..."
    }, 21000);
  }

  show() {
    // Method no longer used.
  }

  // preview(event) {
  //   const input = event.target;
  //   if (input.files && input.files[0]) {
  //     const reader = new FileReader();

  //     reader.onload = (e) => {
  //       const imagePreview = document.getElementById('image_preview');
  //       imagePreview.src = e.target.result;
  //       imagePreview.style.display = 'block'; // Ensure the image is visible
  //     };

  //     reader.readAsDataURL(input.files[0]);
  //   }
  // }

}
