<script lang="ts">
  import '../../../app.css';

  /** @type {import('./$types').PageData} */
	export let data;

  import yaml from 'js-yaml';

  import type { Interfaces } from '$lib/interfaces';
  import ifcLoad from '$lib/interfaces.yaml?raw';

  import Navigation from '$lib/components/Navigation.svelte';
  import TableLoader from '$lib/components/TableLoader.svelte';
  
  const interfaces = yaml.load(ifcLoad) as Interfaces;

  const p = data.interface;
  const s = data.service;
  const v = data.version;

  const vd = interfaces[p].services[s].versions[v];
  
  const pd = data.protoDoc;
  const files = pd.files;
</script>

<svelte:head>
  <title>{interfaces[p].name} - {interfaces[p].services[s].name} Service {v}</title>
</svelte:head>

<div class="dark:bg-gray-800 pb-2">
  <div class="lg:flex">
    <Navigation interfaces={interfaces} iKey={p} sKey={s} version={v} files={files} srcDoc={vd}/>
    <TableLoader files={files} scalarValueTypes={pd.scalarValueTypes}/>
  </div>
</div>
