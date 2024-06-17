import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bird", "text"]

  connect() {
    console.log("Loading Connected!");
    console.log(this);
  }

  show() {
    console.log("Loading!");
    this.birdTarget.classList.remove('d-none')
    this.textTarget.classList.remove('d-none')
    setTimeout(() => {
      this.textTarget.innerText = "Nearly there..."
    }, 5000);
  }
}
