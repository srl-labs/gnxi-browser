<script>
  import jQuery from "jquery";
  import { onMount } from 'svelte';
  import interfaces from '$lib/interfaces.json'

  /** @type {import('./$types').PageData} */
  export let data;
  const p = data.interface;
  const s = data.service;
  const v = data.version;

  const ov = Object.keys(interfaces[p].services[s].versions);
  const vd = interfaces[p].services[s].versions[v];
  const pd = data.protoDoc;
  const files = pd.files;

  const iconLoop = function(component, color, text, kind) {
    return component.map(v => ({...v, iconColor: color, iconText: text, subSection: kind}))
  }

  files.forEach(entry => {
    entry.all = [];
    if(entry.hasServices) {
      entry.all.push(iconLoop(entry.services, "is-link", "S", "services"));
      delete entry.services;
    }
    if(entry.hasMessages) {
      entry.all.push(iconLoop(entry.messages, "has-background-grey-lighter", "M", "messages"));
      delete entry.messages;
    }
    if(entry.hasEnums) {
      entry.all.push(iconLoop(entry.enums, "is-dark", "E", "enums"));
      delete entry.enums;
    }
    if(entry.hasExtensions) {
      entry.all.push(iconLoop(entry.extensions, "", "X", "extensions"));
      delete entry.extensions;
    }
  })

  onMount(() => {
    // JQUERY CASE INSENSITIVE CONTAINS
		jQuery.expr[":"].contains = function(a, i, m) {
      return jQuery(a).text().toUpperCase()
        .indexOf(m[3].toUpperCase()) >= 0;
    };
	});

  // FIELD REQUIRED?
  const needField = function(dict, kind) {
    let checkList = [];
    dict.map(function (el) { if(el[kind] != "") checkList.push(true) })
    if(checkList.length > 0) return true;
    else return false;
  }

  // GROUP BY KEY ON A LIST OF OBJECT
  const groupByKey = function(list, key) {
    const groupBy = (list, key) => list.reduce((hash, obj) => ({...hash, [obj[key]]:( hash[obj[key]] || [] ).concat(obj)}), {});
    let tmp = groupBy(list, key);
    return {
      keys: Object.keys(tmp),
      values: tmp
    };
  }

  // CONVERT TO UPPERCASE
  const toUpper = function(arg) {
    return arg.toUpperCase();
  }

  // MENU TOGGLE
  const toggleMenu = function() {
    const menu = document.getElementsByClassName("menu")[0];
    const menuIcon = document.getElementById("navMenuIcon");
    const mcn = menu.className;
    const fadeIn = "animate__fadeInLeft";
    const fadeOut = "animate__fadeOutLeft";
    if(mcn.includes(fadeIn)) {
      menu.classList.remove(fadeIn);
      menu.classList.add(fadeOut);
      menuIcon.innerHTML= '<i class="bx bx-menu"></i>';
    } else {
      menu.classList.remove(fadeOut);
      menu.classList.add(fadeIn);
      menuIcon.innerHTML= '<i class="bx bx-x"></i>';
    }
  }

  // CLEAR SEARCH
  const clearSearch = function() {
    document.getElementById("search").value = "";
    searchSideMenu();
  }

  // SEARCH SIDE MENU
  const searchSideMenu = function() {
    const searchField = document.getElementById("search");
    const menuItem = document.querySelectorAll("list-item");
    var matches = jQuery(".menu-list").find("li:contains(" + searchField.value + ")");
    jQuery("li", ".menu-list").not(matches).slideUp();
    matches.slideDown();
  }
</script>

<svelte:head>
  <title>{interfaces[p].name} - {interfaces[p].services[s].name} Service v{v}</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
</svelte:head>

<div class="overall">
  <nav class="navbar is-fixed-top has-header-img">
    <div class="navbar-brand">
      <!-- svelte-ignore a11y-missing-attribute -->
      <!-- svelte-ignore a11y-click-events-have-key-events -->
      <a class="navbar-item has-text-white" id="navMenuIcon" on:click={toggleMenu}><i class="bx bx-x"></i></a>
      <a class="navbar-item" href="../"><img src="/images/nwhite.png" width="65" alt="Logo"/></a>
      {#if Object.keys(interfaces[p].services).length > 1}
        <div class="navbar-item dropdown is-hoverable">
          <div class="dropdown-trigger">
            <p class="has-text-white" aria-haspopup="true" aria-controls="dropdown-menu">{interfaces[p].name}</p>
          </div>
          <div class="dropdown-menu" id="dropdown-menu" role="menu">
            <div class="dropdown-content">
              {#each Object.keys(interfaces[p].services) as serviceKey}
                {@const serviceName = interfaces[p].services[serviceKey].name}
                {#if serviceKey == s} 
                  <a data-sveltekit-reload href="{serviceKey}" class="dropdown-item is-active">{serviceName}</a>
                {:else} 
                  <a data-sveltekit-reload href="{serviceKey}" class="dropdown-item">{serviceName}</a> 
                {/if}
              {/each}
            </div>
          </div>
        </div>
      {:else}
        <p class="navbar-item has-text-white">{interfaces[p].services[s].name}</p>
      {/if}
      <p class="navbar-item has-text-warning">{interfaces[p].services[s].name} Service</p>
      <div class="navbar-item dropdown is-hoverable">
        <div class="dropdown-trigger">
          {#if ov.length > 1}
            <!-- svelte-ignore a11y-missing-attribute -->
            <a class="has-text-white" aria-haspopup="true" aria-controls="dropdown-menu">v{v}</a>
          {:else}
            <p class="has-text-white">v{v}</p>
          {/if}
        </div>
        {#if ov.length > 0}
          <div class="dropdown-menu" id="dropdown-menu" role="menu">
            <div class="dropdown-content">
              {#each ov as item}
                {#if item !== v} <a data-sveltekit-reload class="navbar-item" href="{s}?version={item}">v{item}</a> {/if}
              {/each}
            </div>
          </div>
        {/if}
      </div>
      <div class="navbar-item">
        <a class="has-text-white" href="{vd.source}">Source</a>
      </div>
      <div class="navbar-item">
        <a class="has-text-white" href="{vd.documentation}">Documentation</a>
      </div>
    </div>
  </nav>
  
  <aside class="menu box p-5 is-sticky-left animate__animated animate__fadeInLeft" on:animationend={clearSearch}>
    <p class="menu-label">Table of Contents</p>
    <div class="control">
      <input class="input" type="text" placeholder="Search" id="search" on:keyup={searchSideMenu}>
    </div>
    <div class="menu-container mt-3 pt-2">
      <ul class="menu-list">
        {#each files as file}
          {#each file.all as hasComponents}
            {@const sectionName = hasComponents[0].subSection}
            <li>
              <a href="#{sectionName}" class="component-section has-text-weight-bold" on:click={toggleMenu}>{toUpper(sectionName)}</a>
              <ul>
                {#each hasComponents as item}
                  <li>
                    <a class="list-item" href="#{item.longName}" on:click={toggleMenu}>
                      <div class="level is-mobile">
                        <div class="level-left">
                          <div class="level-item"><span class="button is-small {item.iconColor} badge">{item.iconText}</span></div>
                          <div class="level-item">{item.longName}</div>
                        </div>
                      </div>
                    </a>
                  </li>
                {/each}
              </ul>
            </li>
          {/each}
        {/each}
      </ul>
    </div>
  </aside>
  
  <div class="main-page">
    {#each files as file}
      {#each file.all as hasComponents}
        {@const sectionName = hasComponents[0].subSection}
        <div class="hero">
          <div class="hero-body">
            <div class="container content">
              <a id="{sectionName}" href="#{sectionName}" class="title is-6 scroll-mt">{toUpper(sectionName)}</a><hr/>
              {#each hasComponents as item}
                <p class="title is-6"><a class="service-item scroll-mt" id="{item.longName}" href="#{item.longName}">{item.longName}</a></p>
                {#if item.description} <p>{@html item.description.replaceAll("\n", "<br>")}</p> {/if}
                <div class="table-container">
                  <table class="table is-fullwidth">
                    {#if sectionName == "services"}
                      {#if item.methods.length > 0}
                        <thead class="has-background-light has-text-weight-bold">
                          <tr>
                            <td>Method Name</td>
                            <td>Request Type</td>
                            <td>Response Type</td>
                            <td>Description</td>
                          </tr>
                        </thead>
                        <tbody>
                          {#each item.methods as z}
                            <tr>
                              <td class="has-text-fira-code">{z.name}</td>
                              <td>
                                <a class="has-text-link has-text-fira-code" href="#{z.requestLongType}">{z.requestLongType}</a> 
                                {#if z.requestStreaming} <span class="has-text-grey-light"> stream</span> {/if}
                              </td>
                              <td>
                                <a class="has-text-link has-text-fira-code" href="#{z.requestLongType}">{z.responseLongType}</a> 
                                {#if z.requestStreaming} <span class="has-text-grey-light"> stream</span> {/if}
                              </td>
                              <td><p>{@html z.description.replaceAll("\n", "<br>")}</p></td>
                            </tr>
                          {/each}
                        </tbody>
                      {:else}
                        <p class="is-italic">Empty service</p>
                      {/if}
                    {:else if sectionName == "messages"}
                      {#if item.fields.length > 0}
                        {@const groups = groupByKey(item.fields, "oneofdecl")}
                        <thead class="has-background-light has-text-weight-bold">
                          <tr>
                            <td>Field</td>
                            <td>Type</td>
                            <td>Description</td>
                          </tr>
                        </thead>
                        <tbody>
                          {#each groups.keys as gk}
                            {#if gk != ""}
                              <tr>
                                <td class="has-text-fira-code" colspan="3">
                                  {gk} <small class="has-text-grey-light has-text-fira-code">(one of)</small>
                                </td>
                              </tr>
                            {/if}
                            {#each groups.values[gk] as z}
                              <tr>
                                {#if gk != ""} 
                                  <td class="indent-4 has-text-fira-code">
                                    {z.name} {#if z.label != ""} 
                                    <span class="has-text-grey-light has-text-fira-code">({z.label})</span> {/if}
                                  </td>
                                {:else}
                                  <td class="has-text-fira-code">
                                    {z.name} 
                                    {#if z.label != ""} <small class="has-text-grey-light has-text-fira-code">({z.label})</small> {/if}
                                  </td>
                                {/if}
                                <td><a class="has-text-link has-text-fira-code" href="#{z.fullType}">{z.longType}</a></td>
                                <td>
                                  <p>
                                    {#if item.options && item.options == "deprecated"} <strong>Deprecated.</strong> {/if} 
                                    {@html z.description.replaceAll("\n", "<br>")} {#if z.defaultValue} Default: {z.defaultValue} {/if}
                                  </p>
                                </td>
                              </tr>
                            {/each}
                          {/each}
                        </tbody>
                      {:else}
                        <p class="is-italic">Empty message</p>
                      {/if}
                    {:else if sectionName == "enums"}
                      {#if item.values.length > 0}
                        <thead class="has-background-light has-text-weight-bold">
                          <tr>
                            <td>Name</td>
                            <td>Number</td>
                            <td>Description</td>
                          </tr>
                        </thead>
                        <tbody>
                          {#each item.values as z}
                            <tr>
                              <td class="has-text-fira-code">{z.name}</td>
                              <td class="has-text-fira-code">{z.number}</td>
                              <td>{@html z.description.replaceAll("\n", "<br>")}</td>
                            </tr>
                          {/each}
                        </tbody>
                      {:else}
                        <p class="is-italic">Empty enum</p>
                      {/if}
                    {:else if sectionName == "extensions"}
                      <thead class="has-background-light has-text-weight-bold">
                        <tr>
                          <td>Extension</td>
                          <td>Type</td>
                          <td>Base</td>
                          <td>Number</td>
                          <td>Description</td>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td class="has-text-fira-code">{item.name}</td>
                          <td><a class="has-text-link has-text-fira-code" href="#{item.fullType}">{item.longType}</a></td>
                          <td><a class="has-text-link has-text-fira-code" href="#{item.containingFullType}">{item.containingLongType}</a></td>
                          <td class="has-text-fira-code">{item.number}</td>
                          <td>
                            <p>{@html item.description.replaceAll("\n", "<br>")} {#if item.defaultValue} Default: {item.defaultValue} {/if}</p>
                          </td>
                        </tr>
                      </tbody>
                    {/if}
                  </table>
                </div>
              {/each}
            </div>
          </div>
        </div>
      {/each}
    {/each}
    <div class="hero">
      <div class="hero-body">
        <div class="container">
          <p class="title is-6"><a class="has-text-black" id="scalar-value-types" href="#scalar-value-types">SCALAR VALUE TYPES</a></p>
          <div class="table-container">
            <table class="table is-fullwidth">
              <thead class="has-background-light has-text-weight-bold">
                <tr>
                  <td>Proto Type</td>
                  <td>Notes</td>
                  <td>C++</td>
                  <td>Java</td>
                  <td>Python</td>
                  <td>Go</td>
                  <td>C#</td>
                  <td>PHP</td>
                  <td>Ruby</td>
                </tr>
              </thead>
              <tbody>
                {#each pd.scalarValueTypes as svt}
                  <tr id="{svt.protoType}">
                    <td>{svt.protoType}</td>
                    <td>{svt.notes}</td>
                    <td>{svt.cppType}</td>
                    <td>{svt.javaType}</td>
                    <td>{svt.pythonType}</td>
                    <td>{svt.goType}</td>
                    <td>{svt.csType}</td>
                    <td>{svt.phpType}</td>
                    <td>{svt.rubyType}</td>
                  </tr>
                {/each}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    <div class="hero is-small is-light">
      <div class="hero-body">
        <div class="container has-text-centered is-fluid">
          <p>Created by
            <a class="has-text-link" href="https://www.linkedin.com/in/siva19susi" target="_blank">Siva Sivakumar</a> /
            <a class="has-text-link" href="https://www.linkedin.com/in/rdodin" target="_blank">Roman Dodin</a> /
            <a class="has-text-link" href="https://github.com/srl-labs" target="_blank"><i class="bx bx-fw bxl-github"></i>srl-labs</a>
          </p>
        </div>
      </div>
    </div>
  </div>
</div>