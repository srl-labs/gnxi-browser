<script lang="ts">
  export let files, service_key: string, version: string, other_versions: string[], src_doc;
  const custom = {
    sidebar: {
      label: "text-blue-600 dark:text-blue-500 hover:underline text-[10px] uppercase tracking-widest min-w-[400px]",
      class_outer: "text-sm font-nunito fixed pt-20 left-0 top-0 z-40 transition-transform -translate-x-full bg-white dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700",
      class_inner: "h-[calc(100vh_-_10rem)] px-3 pb-4 overflow-y-auto bg-white dark:bg-gray-800",
      section: "flex items-center p-2 rounded-lg text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700",
      search: "block w-full p-2 pl-10 text-sm rounded-lg text-gray-900 dark:text-white focus:ring-blue-500 dark:focus:ring-blue-500 border border-gray-300 focus:border-blue-500 dark:border-gray-600 dark:focus:border-blue-500 bg-gray-50 dark:bg-gray-700 dark:placeholder-gray-400",
      expand: {
        icon: "w-5 h-5 transition duration-75 rounded-full",
        package: "flex items-center w-full p-2 transition duration-75 rounded-lg text-black dark:text-white bg-gray-100 dark:bg-gray-900 hover:bg-gray-200 dark:hover:bg-gray-700",
        header: "flex items-center w-full p-2 transition duration-75 rounded-lg text-black dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700",
        content: {
          border: "py-2 space-y-2 border-l ml-4",
          entry: "flex mx-3 py-2 px-2 transition duration-75 text-gray-900 dark:text-white rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700"
        }
      },
      svg: {
        view: "0 0 24 24",
        class: "w-5 h-5 transition duration-75 text-gray-500 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white",
        path: {
          search: "M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z",
          link: "M13.19 8.688a4.5 4.5 0 011.242 7.244l-4.5 4.5a4.5 4.5 0 01-6.364-6.364l1.757-1.757m13.35-.622l1.757-1.757a4.5 4.5 0 00-6.364-6.364l-4.5 4.5a4.5 4.5 0 001.242 7.244",
          list: "M8.25 6.75h12M8.25 12h12m-12 5.25h12M3.75 6.75h.007v.008H3.75V6.75zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zM3.75 12h.007v.008H3.75V12zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm-.375 5.25h.007v.008H3.75v-.008zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z",
          expand: "M3.75 12h16.5m-16.5 3.75h16.5M3.75 19.5h16.5M5.625 4.5h12.75a1.875 1.875 0 010 3.75H5.625a1.875 1.875 0 010-3.75z"
        }
      }
    }
  }

  const loopEntry = (l: string, f: string, i: number) => {
    let loopName = i === 0 ? l: f;
    return `<li><a href="#${loopName}" class="${custom.sidebar.expand.content.entry}">${loopName}</a></li>`;
  }
</script>

<aside id="sidebar" class="{custom.sidebar.class_outer}">
  <div class="p-1 bg-white dark:bg-gray-800">
    <div class="px-3 text-center">
      <a href="{src_doc.source}" class="{custom.sidebar.label}">Source</a> 
      <span class="text-black dark:text-white">/</span> 
      <a href="{src_doc.documentation}" class="{custom.sidebar.label}">Documentation</a>
    </div>
    <div class="relative mx-2 my-2">
      <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
        <svg aria-hidden="true" class="{custom.sidebar.svg.class}" fill="none" stroke="currentColor" viewBox="{custom.sidebar.svg.view}" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="{custom.sidebar.svg.path.search}"></path>
        </svg>
      </div>
      <input type="search" id="search" class="{custom.sidebar.search}" placeholder="Search...">
    </div>
  </div>
  <div class="{custom.sidebar.class_inner}">
    <ul class="space-y-2">
      <li class="dropdown md:hidden">
        <button type="button" class="{custom.sidebar.expand.header}">
          <svg class="{custom.sidebar.svg.class}" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="{custom.sidebar.svg.view}" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
            <path stroke-linecap="round" stroke-linejoin="round" d="{custom.sidebar.svg.path.expand}"></path>
          </svg>
          <span class="ml-3">{version}</span>
        </button>
        <ul class="hidden py-2 space-y-2 dropdown-menu">
          {#each other_versions as ov}
            <li>
              {#if ov != version} <a data-sveltekit-reload href="{service_key}?version={ov}" class="{custom.sidebar.expand.content.entry}">{ov}</a> {/if}
            </li>
          {/each}
        </ul>
      </li>
      {#each files as entry, i}
        {@const packageName = entry.package}
        <li class="dropdown">
          <a class="{custom.sidebar.expand.package}" href="#{packageName}">{packageName}</a>
          <ul class="py-2 space-y-2 ml-2 dropdown-menu">
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
                    {@html loopEntry(item.longName, item.fullName, i)}
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
                    {@html loopEntry(item.longName, item.fullName, i)}
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
                    {@html loopEntry(item.longName, item.fullName, i)}
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
                    {@html loopEntry(item.longName, item.fullName, i)}
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
