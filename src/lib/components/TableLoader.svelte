<script lang="ts">
  export let files: any, scalarValueTypes: any;
  import Table from './Table.svelte';

  const isImported = (i: number) => { 
    let validate = i === 0 ? false: true;
    return validate;
  }
</script>

<div class="mt-16">
  {#each files as entry, i}
    {@const packageName = entry.package}
    <div class="container mx-auto mt-6 px-6 text-center">
      <div class="bg-gray-100 dark:bg-gray-900 py-3">
        <a class="text-black dark:text-white hover:underline font-nunito" id="{packageName}" href="#{packageName}">{packageName}</a>
      </div>
    </div>
    {#if entry.hasServices}
      {@const sectionName = "services"}
      {@const hrefSection = packageName + "." + sectionName}
      <div class="container mx-auto p-6">
        <div class="my-1">
          <a class="text-black dark:text-white hover:underline font-nunito uppercase" id="{hrefSection}" href="#{hrefSection}">{sectionName}</a>
        </div>
        <Table entry={entry.services} sectionName={sectionName} imported={isImported(i)}/>
      </div>
    {/if}
    {#if entry.hasMessages}
      {@const sectionName = "messages"}
      {@const hrefSection = packageName + "." + sectionName}
      <div class="container mx-auto p-6">
        <div class="my-1">
          <a class="text-black dark:text-white hover:underline font-nunito uppercase" id="{hrefSection}" href="#{hrefSection}">{sectionName}</a>
        </div>
        <Table entry={entry.messages} sectionName={sectionName} imported={isImported(i)}/>
      </div>
    {/if}
    {#if entry.hasEnums}
      {@const sectionName = "enums"}
      {@const hrefSection = packageName + "." + sectionName}
      <div class="container mx-auto p-6">
        <div class="my-1">
          <a class="text-black dark:text-white hover:underline font-nunito uppercase" id="{hrefSection}" href="#{hrefSection}">{sectionName}</a>
        </div>
        <Table entry={entry.enums} sectionName={sectionName} imported={isImported(i)}/>
      </div>
    {/if}
    {#if entry.hasExtensions}
      {@const sectionName = "extensions"}
      {@const hrefSection = packageName + "." + sectionName}
      <div class="container mx-auto p-6">
        <div class="my-1">
          <a class="text-black dark:text-white hover:underline font-nunito uppercase" id="{hrefSection}" href="#{hrefSection}">{sectionName}</a>
        </div>
        <Table entry={entry.extensions} sectionName={sectionName} imported={isImported(i)}/>
      </div>
    {/if}
  {/each}
  <div class="container mx-auto p-6">
    <Table entry={scalarValueTypes} sectionName="svt" imported={false}/>
  </div>
</div>