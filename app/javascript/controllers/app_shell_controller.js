import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.applyStoredDarkMode()
  }

  applyStoredDarkMode() {
    const storedDarkMode = JSON.parse(window.localStorage.getItem("darkMode") || "false")
    document.documentElement.classList.toggle("dark", storedDarkMode)
    document.body.classList.toggle("bg-gray-900", storedDarkMode)
  }
}
