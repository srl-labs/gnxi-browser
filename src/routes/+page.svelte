<script lang="ts">
	import '../app.css';

	import yaml from 'js-yaml';
	import { onMount } from 'svelte';
	import { page } from '$app/stores';

	import Footer from '$lib/components/Footer.svelte';

	import type { Interfaces } from '$lib/interfaces';
	import ifcLoad from '$lib/interfaces.yaml?raw';

	const interfaces = yaml.load(ifcLoad) as Interfaces;
	const productKeys = Object.keys(interfaces);

	let currentPanel = '';
	let panelList: { name: string; desc: string; href: string }[] = [];
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
	};

	fillPanelList('onload');
</script>

<svelte:head>
	<title>gNXI Protobuf Documentation</title>
	<link rel="canonical" href="https://gnxi.srlinux.dev{$page.url.pathname}" />
</svelte:head>

<div class="flex flex-col items-center min-h-screen pt-5 has-header-img font-nunito">
	<div class="flex-grow-1 flex-shrink-0 m-auto px-10">
		<div class="md:grid md:grid-cols-2 md:gap-20 md:items-center">
			<div class="py-5">
				<p class="mb-4"><img src="/images/nwhite.png" width="100" alt="Logo" /></p>
				<h3 class="text-3xl text-yellow-200 font-light mt-6">gNxI Protobuf Documentation</h3>
				<p class="mt-4 text-white text-m max-w-[450px]">
					User interface for Openconfig's gRPC services <sup
						><a
							class="text-white-400 hover:text-blue-300"
							href="https://learn.srlinux.dev/blog/2023/gnxi-browser-a-documentation-ui-for-openconfig-grpc-services/"
							><svg
								class="w-4 h-4 inline-flex"
								xmlns="http://www.w3.org/2000/svg"
								fill="currentColor"
								viewBox="0 0 24 24"
								><path
									d="M10.97 8.265a1.45 1.45 0 0 0-.487.57.75.75 0 0 1-1.341-.67c.2-.402.513-.826.997-1.148C10.627 6.69 11.244 6.5 12 6.5c.658 0 1.369.195 1.934.619a2.45 2.45 0 0 1 1.004 2.006c0 1.033-.513 1.72-1.027 2.215-.19.183-.399.358-.579.508l-.147.123a4.329 4.329 0 0 0-.435.409v1.37a.75.75 0 1 1-1.5 0v-1.473c0-.237.067-.504.247-.736.22-.28.486-.517.718-.714l.183-.153.001-.001c.172-.143.324-.27.47-.412.368-.355.569-.676.569-1.136a.953.953 0 0 0-.404-.806C12.766 8.118 12.384 8 12 8c-.494 0-.814.121-1.03.265ZM13 17a1 1 0 1 1-2 0 1 1 0 0 1 2 0Z" /><path
									d="M12 1c6.075 0 11 4.925 11 11s-4.925 11-11 11S1 18.075 1 12 5.925 1 12 1ZM2.5 12a9.5 9.5 0 0 0 9.5 9.5 9.5 9.5 0 0 0 9.5-9.5A9.5 9.5 0 0 0 12 2.5 9.5 9.5 0 0 0 2.5 12Z" /></svg
							></a
						></sup>
				</p>
			</div>
			<div class="bg-white rounded">
				<div class="bg-gray-50 p-4 rounded-t">
					<ul
						class="flex flex-wrap text-sm font-medium text-center text-gray-500 dark:text-gray-400">
						{#each productKeys as p}
							{@const ifcName = interfaces[p].name}
							<li class="mr-2">
								<!-- svelte-ignore a11y-missing-attribute -->
								<!-- svelte-ignore a11y-click-events-have-key-events -->
								<a
									on:click={fillPanelList}
									class="inline-block px-3 py-2 rounded-lg cursor-pointer {currentPanel === ifcName
										? 'bg-blue-600 text-white'
										: 'hover:text-gray-900 hover:bg-gray-200'}">{ifcName}</a>
							</li>
						{/each}
					</ul>
				</div>
				<div
					class="h-[300px] max-w-[450px] lg:w-[450px] p-4 overflow-y-auto scroll-light shadow-[rgba(13,_38,_76,_0.19)_0px_9px_20px]">
					<ul>
						{#each panelList as item}
							<li class="items-center p-4 rounded-lg text-gray-900 hover:bg-gray-100">
								<a href={item.href}>
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
		<Footer home={true} />
	</div>
</div>
