import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reset() {
    console.log("How am in here")
    this.element.reset()
  }
}
