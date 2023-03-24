<script>
  import interfaces from '$lib/interfaces.json'
  const productKeys = Object.keys(interfaces);

  const extract = function(component, action) {
    if(action == "getKeys") {
      return Object.keys(component);
    } else if(action == "getFirstKey") {
      return Object.keys(component)[0];
    }
  }
</script>

<svelte:head>
  <title>gNXI Protobuf Documentation</title>
</svelte:head>

<section class="hero is-fullheight has-header-img">
  <div class="hero-body">
    <div class="container has-text-centered">
      <p class="mb-4"><img src="/images/nwhite.png" width="100" alt="Logo"/></p>
      <h3 class="title is-3 has-text-weight-light has-text-warning" id="title">gNXI Protobuf Documentation</h3>
      <div class="buttons is-centered">
        {#each productKeys as p}
          {@const ifcServices = interfaces[p].services}
          {#if extract(ifcServices, "getKeys").length > 1}
            <div class="dropdown is-hoverable">
              <div class="dropdown-trigger">
                <button class="button is-light is-outlined" aria-haspopup="true" aria-controls="dropdown-menu">
                  {interfaces[p].name} <i class='bx bx-chevron-down'></i>
                </button>
              </div>
              <div class="dropdown-menu" id="dropdown-menu" role="menu">
                <div class="dropdown-content has-text-left">
                  {#each extract(ifcServices, "getKeys") as serviceKey}
                    <a href="{p}/{serviceKey}/" class="dropdown-item">{ifcServices[serviceKey].name}</a>
                  {/each}
                </div>
              </div>
            </div>
          {:else}
            {@const serviceKey = extract(ifcServices, "getFirstKey")}
            <a href="{p}/{serviceKey}/" class="button is-light is-outlined">{ifcServices[serviceKey].name}</a>
          {/if}
        {/each}
      </div>
    </div>
  </div>
  <div class="hero-foot">
    <div class="container has-text-centered pb-3">
      <p class="has-text-light">Created by
        <a class="has-text-primary" href="https://www.linkedin.com/in/siva19susi" target="_blank">Siva Sivakumar</a> /
        <a class="has-text-primary" href="https://www.linkedin.com/in/rdodin" target="_blank">Roman Dodin</a> /
        <a class="has-text-primary" href="https://github.com/srl-labs" target="_blank"><i class="bx bx-fw bxl-github"></i>srl-labs</a>
      </p>
    </div>
  </div>
</section>