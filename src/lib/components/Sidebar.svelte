<script lang="ts">
  import jQuery from "jquery";
	import { onMount } from 'svelte';
  import { toggleSidebar } from './functions';

  export let files: any, src_doc;
  let lookup = "";

  onMount(() => {
    jQuery.expr[':'].contains = function(a, i, m) {
      return jQuery(a).text().toUpperCase()
        .indexOf(m[3].toUpperCase()) >= 0;
    };
  })

  const searchSide = () => {
    var matches = jQuery("#sideList").find("li:contains(" + lookup + ")");
    jQuery("li", "#sideList").not(matches).slideUp();
    matches.slideDown();
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

<aside id="sidebar" class="text-sm font-nunito fixed pt-20 left-0 top-0 z-20 transition-transform duration-700 -translate-x-full bg-white dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700">
  <div class="bg-white dark:bg-gray-800">
    <div class="px-3 text-center">
      <a href="{src_doc.source}" class="text-blue-600 dark:text-blue-500 hover:underline text-[10px] uppercase">Source</a> 
      <span class="text-black dark:text-white">/</span> 
      <a href="{src_doc.documentation}" class="text-blue-600 dark:text-blue-500 hover:underline text-[10px] uppercase">Documentation</a>
    </div>
    <div class="ml-4 mr-6 mt-2 mb-4">
      <input type="text" placeholder="Search..." bind:value={lookup} on:keyup={searchSide} class="w-full px-3 py-2 text-sm rounded-lg text-gray-900 dark:text-white border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 dark:placeholder-gray-400">
    </div>
  </div>
  <div id="sideList" class="px-3 pb-4 min-w-[300px] h-[calc(100vh_-_10rem)] overflow-y-auto scroll-light dark:scroll-dark bg-white dark:bg-gray-800">
    <ul class="space-y-2">
      {#each files as entry, i}
        {@const packageName = entry.package}
        <li>
          <a class="{custom.sidebar.expand.package}" href="#{packageName}">{packageName}</a>
          <ul class="py-2 space-y-2 ml-2">
            {#if entry.hasServices}
              <li>
                <a href="#{packageName + ".services"}">
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
                <a href="#{packageName + ".messages"}">
                  <button type="button" class="{custom.sidebar.expand.header}">
                    <span class="{custom.sidebar.expand.icon} text-white bg-gray-400">M</span>
                    <span class="ml-3 uppercase">Messages</span>
                  </button>
                </a>
                <ul class="{custom.sidebar.expand.content.border} border-gray-400">
                  {#each entry.messages as item}
                    {@const loopName = i === 0 ? item.longName: item.fullName}
                    <li><a href="#{loopName}" class="{custom.sidebar.expand.content.entry}" on:click={toggleSidebar}>{loopName}</a></li>
                  {/each}
                </ul>
              </li>
            {/if}
            {#if entry.hasEnums}
              <li>
                <a href="#{packageName + ".enums"}">
                  <button type="button" class="{custom.sidebar.expand.header}">
                    <span class="{custom.sidebar.expand.icon} text-white bg-slate-600">E</span>
                    <span class="ml-3 uppercase">Enums</span>
                  </button>
                </a>
                <ul class="{custom.sidebar.expand.content.border} border-slate-600">
                  {#each entry.enums as item}
                    {@const loopName = i === 0 ? item.longName: item.fullName}
                    <li><a href="#{loopName}" class="{custom.sidebar.expand.content.entry}" on:click={toggleSidebar}>{loopName}</a></li>
                  {/each}
                </ul>
              </li>
            {/if}
            {#if entry.hasExtensions}
              <li>
                <a href="#{packageName + ".extensions"}">
                  <button type="button" class="{custom.sidebar.expand.header}">
                    <span class="{custom.sidebar.expand.icon} text-black bg-gray-200">X</span>
                    <span class="ml-3 uppercase">Extensions</span>
                  </button>
                </a>
                <ul class="{custom.sidebar.expand.content.border} border-gray-200">
                  {#each entry.extensions as item}
                    {@const loopName = i === 0 ? item.longName: item.fullName}
                    <li><a href="#{loopName}" class="{custom.sidebar.expand.content.entry}" on:click={toggleSidebar}>{loopName}</a></li>
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
