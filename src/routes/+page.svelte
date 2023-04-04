<script>
	import yaml from 'js-yaml';
	import ifcLoad from '$lib/interfaces.yaml?raw';

	const interfaces = yaml.load(ifcLoad);
	const productKeys = Object.keys(interfaces);

	let panelList = [];
	let currentPanel = '';
	const fillPanelList = (e) => {
		panelList = [];
		if (currentPanel != '') {
			currentPanel = e.target.innerHTML;
		} else {
			currentPanel = 'gNOI';
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
	fillPanelList();
</script>

<svelte:head>
	<title>gNXI Protobuf Documentation</title>
</svelte:head>

<section class="hero is-fullheight has-header-img">
	<div class="hero-body">
		<div class="container">
			<div class="columns is-vcentered">
				<div class="column">
					<p class="mb-4"><img src="/images/nwhite.png" width="100" alt="Logo" /></p>
					<h3 class="title is-3 has-text-warning" id="title">gNXI Protobuf Documentation</h3>
				</div>
				<div class="column">
					<div class="box has-perfect-white">
						<div class="tabs is-medium is-centered is-toggle">
							<ul>
								{#each productKeys as p}
									{@const ifcName = interfaces[p].name}
									<li class:is-active={currentPanel === ifcName}>
										<!-- svelte-ignore a11y-missing-attribute -->
										<!-- svelte-ignore a11y-click-events-have-key-events -->
										<a on:click={fillPanelList}>{ifcName}</a>
									</li>
								{/each}
							</ul>
						</div>
						<div class="panel-container">
							{#each panelList as item}
								<a class="panel-block" href={item.href}>
									<div class="media-content">
										<p class="has-text-link">{item.name}</p>
										<div class="content"><p>{item.desc}</p></div>
									</div>
								</a>
							{/each}
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="hero-foot">
		<div class="container has-text-centered pb-3">
			<p class="has-text-light">
				Created by
				<a class="has-text-primary" href="https://www.linkedin.com/in/siva19susi" target="_blank"
					>Siva Sivakumar</a
				>
				/
				<a class="has-text-primary" href="https://www.linkedin.com/in/rdodin" target="_blank"
					>Roman Dodin</a
				>
				/
				<a class="has-text-primary" href="https://github.com/srl-labs/gnxi-browser" target="_blank"
					><i class="bx bx-fw bxl-github" />srl-labs</a
				>
			</p>
		</div>
	</div>
</section>

<style>
	.panel-container {
		height: 400px;
		overflow: auto;
	}
</style>
