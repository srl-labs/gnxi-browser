<script lang="ts">
  export let files, scalarValueTypes;
  import Table from './Table.svelte';

  const custom = {
    package: {
      container_outer: "container mx-auto mt-6 px-6 text-center",
      container_inner: "bg-gray-100 dark:bg-gray-900 py-3",
      title: "text-xl text-black dark:text-white hover:underline font-nunito"
    },
    section: {
      container: "container mx-auto p-6",
      title: "text-black dark:text-white hover:underline font-nunito uppercase",
      hr: "my-3 sm:mx-auto border-gray-200 dark:border-gray-700"
    }
  }

  const section = (packageName: string, sectionName: string) => {
    let hrefSection = packageName + "." + sectionName;
    return `<div class="my-2">
        <a class="${custom.section.title}" id="${hrefSection}" href="#${hrefSection}">${sectionName}</a>
      </div>`;
  }

  const isImported = (i: number) => { 
    let validate = i === 0 ? false: true;
    return validate;
  }
</script>

<div class="mt-16">
  {#each files as entry, i}
    {@const packageName = entry.package}
    <div class="{custom.package.container_outer}">
      <div class="{custom.package.container_inner}">
        <a class="{custom.package.title}" id="{packageName}" href="#{packageName}">{packageName}</a>
      </div>
    </div>
    {#if entry.hasServices}
      {@const sectionName = "services"}
      <div class="{custom.section.container}">
        {@html section(packageName, sectionName)}
        <Table entry={entry.services} sectionName={sectionName} imported={isImported(i)}/>
      </div>
    {/if}
    {#if entry.hasMessages}
      {@const sectionName = "messages"}
      <div class="{custom.section.container}">
        {@html section(packageName, sectionName)}
        <Table entry={entry.messages} sectionName={sectionName} imported={isImported(i)}/>
      </div>
    {/if}
    {#if entry.hasEnums}
      {@const sectionName = "enums"}
      <div class="{custom.section.container}">
        {@html section(packageName, sectionName)}
        <Table entry={entry.enums} sectionName={sectionName} imported={isImported(i)}/>
      </div>
    {/if}
    {#if entry.hasExtensions}
      {@const sectionName = "extensions"}
      <div class="{custom.section.container}">
        {@html section(packageName, sectionName)}
        <Table entry={entry.extensions} sectionName={sectionName} imported={isImported(i)}/>
      </div>
    {/if}
  {/each}
  <div class="{custom.section.container}">
    <Table entry={scalarValueTypes} sectionName="svt" imported={false}/>
  </div>
</div>