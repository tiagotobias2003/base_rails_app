import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.isOpen = false
    this.render()
  }

  open() {
    this.isOpen = true
    this.render()
  }

  close() {
    this.isOpen = false
    window.dispatchEvent(new CustomEvent("sidebar:close"))
    this.render()
  }

  toggle() {
    this.isOpen = !this.isOpen
    this.render()
  }

  render() {
    this.element.classList.toggle("hidden", !this.isOpen)
    this.element.classList.toggle("block", this.isOpen)
  }
}
