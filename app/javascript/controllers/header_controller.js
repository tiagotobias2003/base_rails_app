import { Controller } from "@hotwired/stimulus"

const SIDEBAR_STATE_STORAGE_KEY = "sidebarOpen"

export default class extends Controller {
  static targets = [
    "sidebarButton",
    "sidebarOpenIcon",
    "sidebarCloseIcon",
    "menuButton",
    "menuContainer",
    "notificationDot",
    "notificationDropdown",
    "notificationArea",
    "userDropdown",
    "userArrow",
    "userArea"
  ]

  connect() {
    const defaultSidebarState = window.matchMedia("(min-width: 1024px)").matches
    const persistedSidebarState = window.localStorage.getItem(SIDEBAR_STATE_STORAGE_KEY)
    this.sidebarOpen = persistedSidebarState === null ? defaultSidebarState : persistedSidebarState === "true"
    this.menuOpen = false
    this.notificationsOpen = false
    this.userDropdownOpen = false
    this.notifying = true
    this.render()
  }

  toggleSidebar(event) {
    event.preventDefault()
    event.stopPropagation()
    this.sidebarOpen = !this.sidebarOpen
    window.localStorage.setItem(SIDEBAR_STATE_STORAGE_KEY, String(this.sidebarOpen))
    window.dispatchEvent(new CustomEvent(this.sidebarOpen ? "sidebar:open" : "sidebar:close"))
    this.render()
  }

  openSidebar() {
    this.sidebarOpen = true
    window.localStorage.setItem(SIDEBAR_STATE_STORAGE_KEY, "true")
    this.render()
  }

  closeSidebar() {
    this.sidebarOpen = false
    window.localStorage.setItem(SIDEBAR_STATE_STORAGE_KEY, "false")
    this.render()
  }

  toggleMenu(event) {
    event.preventDefault()
    event.stopPropagation()
    this.menuOpen = !this.menuOpen
    this.render()
  }

  toggleDarkMode(event) {
    event.preventDefault()
    const isDark = document.documentElement.classList.toggle("dark")
    document.body.classList.toggle("bg-gray-900", isDark)
    window.localStorage.setItem("darkMode", JSON.stringify(isDark))
  }

  toggleNotifications(event) {
    event.preventDefault()
    event.stopPropagation()
    this.notificationsOpen = !this.notificationsOpen
    this.notifying = false
    if (this.notificationsOpen) this.userDropdownOpen = false
    this.render()
  }

  closeNotifications(event) {
    if (event) event.preventDefault()
    this.notificationsOpen = false
    this.render()
  }

  toggleUserDropdown(event) {
    event.preventDefault()
    event.stopPropagation()
    this.userDropdownOpen = !this.userDropdownOpen
    if (this.userDropdownOpen) this.notificationsOpen = false
    this.render()
  }

  handleWindowClick(event) {
    if (!this.notificationAreaTarget.contains(event.target)) {
      this.notificationsOpen = false
    }

    if (!this.userAreaTarget.contains(event.target)) {
      this.userDropdownOpen = false
    }

    this.render()
  }

  render() {
    this.sidebarButtonTarget.classList.toggle("bg-gray-100", this.sidebarOpen)
    this.sidebarButtonTarget.classList.toggle("dark:bg-gray-800", this.sidebarOpen)
    this.sidebarButtonTarget.classList.toggle("lg:bg-transparent", this.sidebarOpen)
    this.sidebarButtonTarget.classList.toggle("dark:lg:bg-transparent", this.sidebarOpen)

    this.sidebarOpenIconTarget.classList.toggle("hidden", this.sidebarOpen)
    this.sidebarOpenIconTarget.classList.toggle("block", !this.sidebarOpen)
    this.sidebarCloseIconTarget.classList.toggle("hidden", !this.sidebarOpen)
    this.sidebarCloseIconTarget.classList.toggle("block", this.sidebarOpen)

    this.menuButtonTarget.classList.toggle("bg-gray-100", this.menuOpen)
    this.menuButtonTarget.classList.toggle("dark:bg-gray-800", this.menuOpen)
    this.menuContainerTarget.classList.toggle("hidden", !this.menuOpen)
    this.menuContainerTarget.classList.toggle("flex", this.menuOpen)

    this.notificationDotTarget.classList.toggle("hidden", !this.notifying)
    this.notificationDotTarget.classList.toggle("flex", this.notifying)
    this.notificationDropdownTarget.classList.toggle("hidden", !this.notificationsOpen)
    this.notificationDropdownTarget.classList.toggle("flex", this.notificationsOpen)

    this.userArrowTarget.classList.toggle("rotate-180", this.userDropdownOpen)
    this.userDropdownTarget.classList.toggle("hidden", !this.userDropdownOpen)
    this.userDropdownTarget.classList.toggle("flex", this.userDropdownOpen)
  }
}
