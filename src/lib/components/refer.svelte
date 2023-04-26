<div class="flex px-3">
  <div class="dropdown inline-block relative">
    <button class="inline-flex items-center px-2 py-1 rounded dark:text-gray-200">
      <span>Interfaces</span>
      <svg class="w-5 h-5 ml-1" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
        <path d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"></path>
      </svg>
    </button>
    <ul class="dropdown-content absolute hidden bg-white rounded-lg shadow w-40 dark:bg-gray-700">
      <li><a class="px-4 py-2 block rounded-t dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600" href="#">Option 1</a></li>
      <li><a class="px-4 py-2 block dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600" href="#">Option 2</a></li>
      <li class="dropdown">
        <a class="px-4 py-2 block dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600" href="#">Option 3 ?</a>
          <ul class="dropdown-content absolute hidden bg-white rounded-lg shadow w-40 dark:bg-gray-700 -mt-9">
            <li><a class="px-4 py-2 block rounded-t dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600" href="#">Option 3-1</a>
            <li><a class="px-4 py-2 block rounded-b dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600" href="#">Option 3-2</a>
          </ul>
      </li>
      <li><a class="px-4 py-2 block rounded-b dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600" href="#">Option 4</a></li>
    </ul>
  </div>
</div>
</div>


<div class="flex px-3">
  <div class="group/level-1 inline-block relative">
    <button class="inline-flex items-center px-2 py-1 rounded dark:text-gray-200">
      <span>Interfaces</span>
      <svg class="w-5 h-5 ml-1" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
        <path d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"></path>
      </svg>
    </button>
    <ul class="absolute hidden rounded-lg shadow w-40 bg-white dark:bg-gray-700 pt-5 top-full left-0 group-hover/level-1:block">
      {#each Object.keys(interfaces) as ifc}
        <li class="group/level-2">
          <a class="px-4 py-2 block rounded-b dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600" href="#">{interfaces[ifc].name}</a>
          <ul class="absolute hidden ml-40 -mt-9 w-40 rounded-lg shadow bg-white dark:bg-gray-700 group-hover/level-2:block">
            {#each Object.keys(interfaces[ifc].services) as svc}
              <li class="group/level-3">
                <a class="px-4 py-2 block rounded-b dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600" href="#">{interfaces[ifc].services[svc].name} Service</a>
                <ul class="absolute hidden ml-40 -mt-9 rounded-lg shadow w-40 bg-white dark:bg-gray-700 group-hover/level-3:block">
                  {#each Object.keys(interfaces[ifc].services[svc].versions) as vrn}
                    <li><a class="px-4 py-2 block rounded-b dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600" href="#">{vrn}</a>
                  {/each}
                </ul>
              </li>
            {/each}
          </ul>
        </li>
      {/each}
    </ul>
  </div>
</div>



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