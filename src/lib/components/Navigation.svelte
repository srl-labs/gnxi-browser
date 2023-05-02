<script lang="ts">
  import jQuery from "jquery";
	import { onMount } from 'svelte';
  import { browser } from '$app/environment';

  export let interfaces: any, iKey: string, sKey: string, version: string, files: any, srcDoc: {source: string, documentation: string};

  let darkMode = false;
  let lookup = "";

  onMount(() => {
    jQuery.expr[':'].contains = function(a: any, i: any, m: string[]) {
      return jQuery(a).text().toUpperCase()
        .indexOf(m[3].toUpperCase()) >= 0;
    };

    if(browser) {
      if(localStorage.theme === "dark" || (!("theme" in localStorage) && window.matchMedia("(prefers-color-scheme: dark)").matches)) {
        darkMode = true;
      } else {
        darkMode = false;
      }
      themeIconSwitch();
    }
  })

  const toggleNavInterfaces = () => {
    document.getElementById("navInterfaces")?.classList.toggle("hidden");
  }

  export const toggleSidebar = () => {
    document.getElementById("sidebar")?.classList.toggle("-translate-x-full");
    document.getElementById("open-sidebar")?.classList.toggle("hidden");
    document.getElementById("close-sidebar")?.classList.toggle("hidden");
    lookup = "";
    searchSide();
  }

  const searchSide = () => {
    let matches = jQuery("#sideList").find("li:contains(" + lookup + ")");
    jQuery("li", "#sideList").not(matches).slideUp();
    matches.slideDown();
  }

  const themeIconSwitch = () => {
    if(darkMode) {
      document.documentElement.classList.add("dark");
      document.getElementById("toggle-dark-icon")?.classList.add("hidden");
      document.getElementById("toggle-light-icon")?.classList.remove("hidden");
    } else {
      document.documentElement.classList.remove("dark");
      document.getElementById("toggle-dark-icon")?.classList.remove("hidden");
      document.getElementById("toggle-light-icon")?.classList.add("hidden");
    }
  }

  const toggleDarkMode = () => {
    darkMode = !darkMode;
    localStorage.setItem("theme", darkMode ? "dark" : "light");
    themeIconSwitch();
  }

  const custom = {
    sidebar: {
      expand: {
        icon: "w-5 h-5 rounded-full",
        package: "flex items-center w-full p-2 rounded-lg text-black dark:text-white bg-gray-100 dark:bg-gray-900 hover:bg-gray-200 dark:hover:bg-gray-700",
        header: "flex items-center w-full p-2 rounded-lg text-black dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700",
        content: {
          border: "py-2 space-y-2 border-l ml-4",
          entry: "flex mx-3 py-2 px-2 text-gray-900 dark:text-white rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700"
        }
      }
    }
  }
</script>

<!-- NAVBAR -->
<nav class="fixed top-0 z-30 px-3 py-4 w-screen select-none text-sm font-nunito bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
  <div class="flex justify-between">
    <!-- navbar left item -->
    <div class="flex items-center">
      <button type="button" class="flex px-2 dark:text-gray-200 lg:hidden" on:click={toggleSidebar}>
        <svg id="open-sidebar" class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 25 25" xmlns="http://www.w3.org/2000/svg">
          <path d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25H12"></path>
        </svg>
        <svg id="close-sidebar" class="w-5 h-5 hidden" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 25 25" xmlns="http://www.w3.org/2000/svg">
          <path d="M6 18L18 6M6 6l12 12"></path>
        </svg>
      </button>
      <div class="flex px-2">
        <a class="w-5" href="../"><img src="/images/navbar-logo.png" alt="Logo"/></a>
      </div>
      <div class="flex px-2 text-sm md:text-xl dark:text-gray-200">
        <span>{interfaces[iKey].services[sKey].name} {version}</span>
      </div>
    </div>
    <!-- navbar right item -->
    <div class="flex items-center">
      <button class="inline-flex px-2" on:click={toggleNavInterfaces}>
        <svg class="w-5 h-5 dark:text-gray-200" fill="none" viewBox="0 0 25 25" stroke-width="1.5" stroke="currentColor" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 6h9.75M10.5 6a1.5 1.5 0 11-3 0m3 0a1.5 1.5 0 10-3 0M3.75 6H7.5m3 12h9.75m-9.75 0a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m-3.75 0H7.5m9-6h3.75m-3.75 0a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m-9.75 0h9.75"/>
        </svg>
      </button>
      <button class="flex px-2" type="button" on:click={toggleDarkMode}>
        <svg id="toggle-light-icon" class="w-5 h-5 dark:text-gray-200 hidden" fill="currentColor" stroke-width="1.5" stroke="currentColor" viewBox="0 0 25 25" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z"/>
        </svg>
        <svg id="toggle-dark-icon" class="w-5 h-5 text-gray-800" fill="currentColor" viewBox="0 0 25 25" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21.752 15.002A9.718 9.718 0 0118 15.75c-5.385 0-9.75-4.365-9.75-9.75 0-1.33.266-2.597.748-3.752A9.753 9.753 0 003 11.25C3 16.635 7.365 21 12.75 21a9.753 9.753 0 009.002-5.998z"/>
        </svg>
      </button>
    </div>
  </div>
</nav>

<!-- INTERFACES + VERSIONS POPUP -->
<div id="navInterfaces" class="fixed inset-0 z-50 font-nunito hidden">
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" on:click={toggleNavInterfaces}></div>
  <div class="flex min-h-full items-center justify-center p-4">
    <div class="relative overflow-hidden rounded-lg shadow-xl bg-white dark:bg-gray-800">
      <h3 class="px-6 py-4 font-semibold leading-6 text-gray-900 dark:text-gray-200 bg-gray-100 dark:bg-gray-700">{interfaces[iKey].name}</h3>
      <div class="px-6 pt-2 pb-4 text-sm max-w-[400px] lg:min-w-[350px] max-h-[500px] overflow-y-auto scroll-light dark:scroll-dark">
        <ul class="py-2 space-y-2">
          {#each Object.keys(interfaces[iKey].services) as svc}
            <li>
              <p class="p-2 dark:text-gray-200 { sKey === svc ? 'bg-gray-100 dark:bg-gray-900 rounded-lg' : ''}">{interfaces[iKey].services[svc].name} Service</p>
              <ul class="py-2 space-y-2 border-l ml-3">
                {#each Object.keys(interfaces[iKey].services[svc].versions) as vrn}
                  <li class="ml-3">
                    <a data-sveltekit-reload class="hover:underline { sKey === svc && version === vrn ? 'text-blue-600 dark:text-blue-500': 'text-blue-300 dark:text-blue-200 hover:text-blue-600 dark:hover:text-blue-500'}" href="{svc}?version={vrn}">{vrn}</a>
                  </li>
                {/each}
              </ul>
            </li>
          {/each}
        </ul>
      </div>
    </div>
  </div>
</div>

<!-- SIDEBAR -->
<aside id="sidebar" class="text-sm font-nunito pt-[70px] fixed left-0 top-0 z-20 transition-transform -translate-x-full lg:-translate-x-0 lg:h-screen lg:sticky bg-white dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700">
  <div class="bg-white dark:bg-gray-800">
    <div class="px-3 text-center">
      <a href="{srcDoc.source}" class="text-blue-600 dark:text-blue-500 hover:underline text-[10px] uppercase">Source</a> 
      <span class="text-black dark:text-white">/</span> 
      <a href="{srcDoc.documentation}" class="text-blue-600 dark:text-blue-500 hover:underline text-[10px] uppercase">Documentation</a>
    </div>
    <div class="ml-5 mr-6 mt-2 mb-4">
      <input type="text" id="search" placeholder="Search..." bind:value={lookup} on:keyup={searchSide} class="w-full px-3 py-2 text-sm rounded-lg text-gray-900 dark:text-white border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 dark:placeholder-gray-400">
    </div>
  </div>
  <div id="sideList" class="px-3 pb-4 min-w-[300px] h-[calc(100vh_-_10rem)] overflow-y-auto scroll-light dark:scroll-dark bg-white dark:bg-gray-800">
    <ul class="space-y-2">
      {#each files as entry, i}
        {@const packageName = entry.name.split("/").pop().split(".")[0]}
        <li>
          <a class="{custom.sidebar.expand.package}" href="#{packageName}" on:click={toggleSidebar}>{packageName}</a>
          <ul class="py-2 space-y-2 ml-2">
            {#if entry.hasServices}
              <li>
                <a href="#{packageName + ".services"}" on:click={toggleSidebar}>
                  <button type="button" class="{custom.sidebar.expand.header}">
                    <span class="{custom.sidebar.expand.icon} text-white bg-blue-600">S</span>
                    <span class="ml-3 uppercase">Services</span>
                  </button>
                </a>
                <ul class="{custom.sidebar.expand.content.border} border-blue-600">
                  {#each entry.services as item}
                    {@const loopName = i === 0 ? item.longName: item.fullName}
                    <li><a href="#{loopName}" class="{custom.sidebar.expand.content.entry}" on:click={toggleSidebar}>{loopName}</a></li>
                  {/each}
                </ul>
              </li>
            {/if}
            {#if entry.hasMessages}
              <li>
                <a href="#{packageName + ".messages"}" on:click={toggleSidebar}>
                  <button type="button" class="{custom.sidebar.expand.header}">
                    <span class="{custom.sidebar.expand.icon} text-white bg-gray-400">M</span>
                    <span class="ml-3 uppercase">Messages</span>
                  </button>
                </a>
                <ul class="{custom.sidebar.expand.content.border} border-gray-400">
                  {#each entry.messages as item}
                    {@const hrefVal = i === 0 ? item.longName: item.fullName}
                    <li><a href="#{hrefVal}" class="{custom.sidebar.expand.content.entry}" on:click={toggleSidebar}>{item.longName}</a></li>
                  {/each}
                </ul>
              </li>
            {/if}
            {#if entry.hasEnums}
              <li>
                <a href="#{packageName + ".enums"}" on:click={toggleSidebar}>
                  <button type="button" class="{custom.sidebar.expand.header}">
                    <span class="{custom.sidebar.expand.icon} text-white bg-slate-600">E</span>
                    <span class="ml-3 uppercase">Enums</span>
                  </button>
                </a>
                <ul class="{custom.sidebar.expand.content.border} border-slate-600">
                  {#each entry.enums as item}
                    {@const hrefVal = i === 0 ? item.longName: item.fullName}
                    <li><a href="#{hrefVal}" class="{custom.sidebar.expand.content.entry}" on:click={toggleSidebar}>{item.longName}</a></li>
                  {/each}
                </ul>
              </li>
            {/if}
            {#if entry.hasExtensions}
              <li>
                <a href="#{packageName + ".extensions"}" on:click={toggleSidebar}>
                  <button type="button" class="{custom.sidebar.expand.header}">
                    <span class="{custom.sidebar.expand.icon} text-black bg-gray-200">X</span>
                    <span class="ml-3 uppercase">Extensions</span>
                  </button>
                </a>
                <ul class="{custom.sidebar.expand.content.border} border-gray-200">
                  {#each entry.extensions as item}
                    {@const hrefVal = i === 0 ? item.longName: item.fullName}
                    <li><a href="#{hrefVal}" class="{custom.sidebar.expand.content.entry}" on:click={toggleSidebar}>{item.longName}</a></li>
                  {/each}
                </ul>
              </li>
            {/if}
          </ul>
        </li>
      {/each}
    </ul>
  </div>
</aside>
