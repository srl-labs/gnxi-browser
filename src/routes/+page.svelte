<script lang="ts">
	import '../app.css';
	
	import yaml from 'js-yaml';
	import { onMount } from 'svelte';
	import { page } from '$app/stores';

	import Footer from '$lib/components/Footer.svelte'

	import type { Interfaces } from '$lib/interfaces';
	import ifcLoad from '$lib/interfaces.yaml?raw';

	const interfaces = yaml.load(ifcLoad) as Interfaces;
	const productKeys = Object.keys(interfaces);

	let currentPanel = '';
	let panelList: { name: string, desc: string, href: string }[] = [];
	const fillPanelList = (e: any) => {
		panelList = [];
		if (currentPanel != '') {
			currentPanel = e.target.innerHTML;
		} else {
			currentPanel = 'gNMI';
		}
		const key = currentPanel.toLowerCase();
		Object.keys(interfaces[key].services).forEach((el) => {
			panelList.push({
				name: interfaces[key].services[el].name,
				desc: interfaces[key].services[el].description,
				href: `${key}/${el}`
			});
		});
	}

	fillPanelList("onload");
</script>

<svelte:head>
	<title>gNXI Protobuf Documentation</title>
	<link rel="canonical" href="https://gnxi.srlinux.dev{$page.url.pathname}" />
</svelte:head>

<div class="flex flex-col items-center min-h-screen pt-5 has-header-img font-nunito">
  <div class="flex-grow-1 flex-shrink-0 m-auto px-10">
    <div class="md:grid md:grid-cols-2 md:gap-10 md:items-center">
      <div class="py-5">
        <p class="mb-4"><img src="/images/nwhite.png" width="100" alt="Logo"/></p>
        <h3 class="text-3xl text-yellow-200 font-light mt-6">gNXI Protobuf Documentation</h3>
      </div>
      <div class="bg-white rounded">
        <div class="bg-gray-50 p-4 rounded-t">
          <ul class="flex flex-wrap text-sm font-medium text-center text-gray-500 dark:text-gray-400">
            {#each productKeys as p}
              {@const ifcName = interfaces[p].name}
              <li class="mr-2">
                <!-- svelte-ignore a11y-missing-attribute -->
                <!-- svelte-ignore a11y-click-events-have-key-events -->
                <a on:click={fillPanelList} class="inline-block px-3 py-2 rounded-lg cursor-pointer {currentPanel === ifcName ? 'bg-blue-600 text-white': 'hover:text-gray-900 hover:bg-gray-200' }">{ifcName}</a>
              </li>
            {/each}
          </ul>
        </div>
        <div class="h-[300px] max-w-[450px] lg:w-[450px] p-4 overflow-y-auto scroll-light shadow-[rgba(13,_38,_76,_0.19)_0px_9px_20px]">
          <ul>
            {#each panelList as item}
              <li class="items-center p-4 rounded-lg text-gray-900 hover:bg-gray-100">
                <a href="{item.href}">
                  <p class="">{item.name}</p>
                  <p class="mt-1 font-light text-sm">{item.desc}</p>
                </a>
              </li>
            {/each}
          </ul>
       </div>
      </div>
    </div>
  </div>
  <div class="flex-grow-0 flex-shrink-0">
    <Footer home={true}/>
  </div>
</div>