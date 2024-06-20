import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]


  connect() {
    console.log("Loading Connected!");
    console.log(this);
    console.log(this.textTarget)
    console.log("Loading!");
    // this.birdTarget.classList.remove('d-none')
    this.textTarget.classList.remove('d-none')
    setTimeout(() => {
      this.textTarget.innerText = "Nearly there..."
    }, 3000);
    setTimeout(() => {
      this.textTarget.innerText = "Building results page..."
    }, 6000);
    setTimeout(() => {
      this.textTarget.innerText = "Finding your exact match..."
    }, 9000);
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
