import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    hideDelay: { type: Number, default: 250 }
  }

  connect() {
    this.hideTimeout = null
    this.show = this.show.bind(this)
    this.hide = this.hide.bind(this)

    // Primeira renderizacao da pagina
    this.hide()

    // Navegacao Turbo (padrao Rails)
    document.addEventListener("turbo:visit", this.show)
    document.addEventListener("turbo:load", this.hide)
  }

  disconnect() {
    this.clearHideTimeout()
    document.removeEventListener("turbo:visit", this.show)
    document.removeEventListener("turbo:load", this.hide)
  }

  show() {
    this.clearHideTimeout()
    this.element.classList.remove("opacity-0", "pointer-events-none")
    this.element.classList.add("opacity-100", "duration-200", "ease-out")
  }

  hide() {
    this.clearHideTimeout()
    this.hideTimeout = setTimeout(() => {
      this.element.classList.remove("opacity-100", "duration-200", "ease-out")
      this.element.classList.add("opacity-0", "pointer-events-none", "duration-300", "ease-in")
    }, this.hideDelayValue)
  }

  clearHideTimeout() {
    if (this.hideTimeout) {
      clearTimeout(this.hideTimeout)
      this.hideTimeout = null
    }
  }
}
