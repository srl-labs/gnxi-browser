<script lang="ts">
  export let service_key: string, service_name: string, version: string, other_versions: string[];

  // TAILWIND CLASS DEFINITION
  const custom = {
    theme: {
      light: "theme-toggle-light-icon",
      dark: "theme-toggle-dark-icon"
    },
    img: {
      class: "h-7 mr-3",
      src: "/images/navbar-logo.png"
    },
    navbar: {
      class: "fixed top-0 z-50 w-full font-nunito bg-white border-b border-gray-200 dark:bg-gray-800 dark:border-gray-700 select-none",
      title: "self-center text-sm md:text-xl whitespace-nowrap text-black dark:text-white",
      item: "p-2 text-black dark:text-white hover:text-gray-600",
      item_static: "p-2 text-black dark:text-white",
      left: "flex mr-2",
      right: "flex ml-2",
      dropdown: {
        menu: "absolute top-full right-0 w-30 z-10 py-2 mr-3 font-normal text-sm text-gray-700 dark:text-gray-400 bg-white dark:bg-gray-700 rounded-lg shadow",
        item: "block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
      }
    },
    svg: {
      class: "w-5 h-5",
      view: "0 0 20 20",
      fill: "currentColor",
      path: {
        close: "M6 18L18 6M6 6l12 12",
        menu: "M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25H12",
        dropdown: "M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z",
        light: "M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z",
        dark: "M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"
      }
    }
  }

  // TOGGLE BETWEEN LIGHT AND DARK MODE
  const toggleDarkMode = () => {
    document.documentElement.classList.toggle('dark');
    document.getElementById(custom.theme.light).classList.toggle('hidden');
    document.getElementById(custom.theme.dark).classList.toggle('hidden');
  }

  const toggleSidebar = () => {
    document.getElementById("sidebar").classList.toggle("translate-x-0");
    document.getElementById("open-sidebar").classList.toggle("hidden");
    document.getElementById("close-sidebar").classList.toggle("hidden");
  }
</script>

<nav class="{custom.navbar.class}">
  <div class="px-3 py-3 lg:px-5 lg:pl-3">
    <div class="flex items-center justify-between">
      <!-- navbar left item -->
      <div class="flex">
        <button class="{custom.navbar.left} {custom.navbar.item}" on:click={toggleSidebar}>
          <svg id="open-sidebar" class="{custom.svg.class}" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="{custom.svg.view}" xmlns="http://www.w3.org/2000/svg">
            <path d="{custom.svg.path.menu}"></path>
          </svg>
          <svg id="close-sidebar" class="{custom.svg.class} hidden" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="{custom.svg.view}" xmlns="http://www.w3.org/2000/svg">
            <path d="{custom.svg.path.close}"></path>
          </svg>
        </button>
        <div class="{custom.navbar.left}">
          <a class="py-2" href="../"><img src="{custom.img.src}" class="{custom.img.class}" alt="Logo"/></a>
          <span class="{custom.navbar.title}">{service_name} Service</span>
        </div>
      </div>
      <!-- navbar right item -->
      <div class="flex">
        <div class="{custom.navbar.right} relative dropdown hidden md:block">
          {#if other_versions.length > 1}
            <button class="{custom.navbar.item} inline-flex">
              {version} 
              <svg class="{custom.svg.class} ml-1" fill="{custom.svg.fill}" viewBox="{custom.svg.view}" xmlns="http://www.w3.org/2000/svg">
                <path d="{custom.svg.path.dropdown}"></path>
              </svg>
            </button>
            <div class="{custom.navbar.dropdown.menu} hidden dropdown-menu">
              <ul>
                {#each other_versions as ov}
                  {#if ov != version} <li><a data-sveltekit-reload href="{service_key}?version={ov}" class="{custom.navbar.dropdown.item}">{ov}</a></li> {/if}
                {/each}
              </ul>
            </div>
          {:else}
            <p class="{custom.navbar.right} {custom.navbar.item_static}">{version}</p>
          {/if}
        </div>
        <button on:click={toggleDarkMode} type="button" class="{custom.navbar.right} {custom.navbar.item}">
          <svg id="{custom.theme.light}" class="{custom.svg.class} text-gray-800" fill="{custom.svg.fill}" viewBox="{custom.svg.view}" xmlns="http://www.w3.org/2000/svg">
            <path d="{custom.svg.path.light}"></path>
          </svg>
          <svg id="{custom.theme.dark}" class="{custom.svg.class} hidden" fill="{custom.svg.fill}" viewBox="{custom.svg.view}" xmlns="http://www.w3.org/2000/svg">
            <path d="{custom.svg.path.dark}"></path>
          </svg>
        </button>
      </div>
    </div>
  </div>
</nav>