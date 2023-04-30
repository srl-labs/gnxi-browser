export const toggleSidebar = () => {
  document.getElementById("sidebar").classList.toggle("-translate-x-full");
  document.getElementById("open-sidebar").classList.toggle("hidden");
  document.getElementById("close-sidebar").classList.toggle("hidden");
}