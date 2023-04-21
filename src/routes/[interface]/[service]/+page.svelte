<script lang="ts">
  import '../../../app.css';

  /** @type {import('./$types').PageData} */
	export let data;

  import yaml from 'js-yaml'

  import type { Interfaces } from '$lib/interfaces';
  import ifcLoad from '$lib/interfaces.yaml?raw'

  import Navbar from '$lib/components/Navbar.svelte'
  import Sidebar from '$lib/components/Sidebar.svelte'
  import TableLoader from '$lib/components/TableLoader.svelte'
  import Footer from '$lib/components/Footer.svelte'
  
  const interfaces = yaml.load(ifcLoad) as Interfaces;

  const p = data.interface;
  const s = data.service;
  const v = data.version;

  const ov = Object.keys(interfaces[p].services[s].versions);
  const vd = interfaces[p].services[s].versions[v];
  
  const pd = data.protoDoc;
  const files = pd.files;
</script>

<svelte:head>
  <title>{interfaces[p].name} - {interfaces[p].services[s].name} Service {v}</title>
</svelte:head>

<div class="dark:bg-gray-800 py-2">
  <Navbar service_key={s} service_name={interfaces[p].services[s].name} version={v} other_versions={ov}/>
  <Sidebar files={files} service_key={s} version={v} other_versions={ov} src_doc={vd}/>
  <TableLoader files={files} scalarValueTypes={pd.scalarValueTypes}/>
  <Footer home={false}/>
</div>
