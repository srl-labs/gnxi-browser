<script lang="ts">
  export let entry, sectionName: string, imported: boolean;

  // TAILWIND CLASS DEFINITION
  const custom = {
    table: {
      section: "text-black dark:text-white hover:underline font-nunito uppercase",
      hr: "my-3 sm:mx-auto border-gray-200 dark:border-gray-700",
      link: "text-blue-600 dark:text-blue-500 hover:underline font-fira",
      desc: "mt-1 text-sm font-normal text-gray-500 dark:text-gray-400 overflow-x-auto",
      container: "overflow-x-auto max-w-full",
      table: "text-left text-gray-500 dark:text-gray-400 w-full font-nunito",
      caption: "pt-7 pb-6 text-left text-lg font-nunito",
      thead: "text-xs uppercase text-gray-700 dark:text-gray-400 bg-gray-50 dark:bg-gray-700",
      tr: "bg-white border-b dark:bg-gray-800 dark:border-gray-700",
      th_col: "px-6 py-3",
      th_row: "px-6 py-4 text-xs text-gray-900 dark:text-white font-fira",
      td: "px-6 py-4 text-xs",
      small: "text-gray-400"
    }
  }

  // FORMAT DESCRIPTION
  const fdesc = (d) => d.replaceAll("\n", "<br>");

  // RE-GROUP BY KEY ON A LIST OF OBJECTS
  const groupByKey = (list, key) => {
    let regrouped = list.reduce((hash, obj) => ({...hash, [obj[key]]:( hash[obj[key]] || [] ).concat(obj)}), {})
    return {
      keys: Object.keys(regrouped),
      values: regrouped
    };
  }
</script>

{#if sectionName != "svt"}
  {#each entry as item}
    <div class="{custom.table.caption}">
      <a class="{custom.table.link}" id="{imported ? item.fullName : item.longName}" href="#{imported ? item.fullName : item.longName}">{imported ? item.fullName : item.longName}</a>
      {#if item.description}
        <p class="{custom.table.desc}">{@html fdesc(item.description)}</p>
      {/if}
    </div>
    <div class="{custom.table.container}">
      <table class="{custom.table.table}">
        {#if sectionName == "services"}
          {#if item.methods.length > 0}
            <thead class="{custom.table.thead}">
              <tr>
                <th scope="col" class="{custom.table.th_col}">Method Name</th>
                <th scope="col" class="{custom.table.th_col}">Request / Response Type</th>
                <th scope="col" class="{custom.table.th_col}">Description</th>
              </tr>
            </thead>
            <tbody>
              {#each item.methods as z, i}
                <tr class="{custom.table.tr}">
                  <th scope="row" class="{custom.table.th_row}">{z.name}</th>
                  <td class="{custom.table.td}">
                    <a class="{custom.table.link}" href="#{imported ? z.requestFullType : z.requestLongType}">{imported ? z.requestFullType : z.requestLongType}</a> {#if z.requestStreaming} stream {/if} <br>
                    <a class="{custom.table.link}" href="#{imported ? z.responseFullType : z.responseLongType}">{imported ? z.responseFullType : z.responseLongType}</a> {#if z.requestStreaming} stream {/if}
                  </td>
                  <td class="{custom.table.td}">
                    <p>{@html fdesc(z.description)}</p>
                  </td>
                </tr>
              {/each}
            </tbody>
          {/if}
          {:else if sectionName == "messages"}
          {#if item.fields.length > 0}
            {@const groups = groupByKey(item.fields, "oneofdecl")}
            <thead class="{custom.table.thead}">
              <tr>
                <th scope="col" class="{custom.table.th_col}">Field</th>
                <th scope="col" class="{custom.table.th_col}">Type</th>
                <th scope="col" class="{custom.table.th_col}">Description</th>
              </tr>
            </thead>
            <tbody>
              {#each groups.keys as gk, i}
                {#if gk != ""}
                  <tr class="{custom.table.tr}">
                    <th scope="row" class="{custom.table.th_row}" colspan="3">
                      {gk} <small class="{custom.table.small}">(one of)</small>
                    </th>
                  </tr>
                {/if}
                {#each groups.values[gk] as z, j}
                  <tr class="{custom.table.tr}">
                    {#if gk != ""} 
                      <th scope="row" class="{custom.table.th_row} indent-5">
                        {z.name} {#if z.label != ""} <span>({z.label})</span> {/if}
                      </th>
                    {:else}
                      <th scope="row" class="{custom.table.th_row}">
                        {z.name} {#if z.label != ""} <small class="{custom.table.small}">({z.label})</small> {/if}
                      </th>
                    {/if}
                    <td class="{custom.table.td}">
                      <a class="{custom.table.link}" href="#{imported ? z.fullType : z.longType}">{imported ? z.fullType : z.longType}</a>
                    </td>
                    <td class="{custom.table.td}">
                      <p>
                        {#if item.options && item.options == "deprecated"} <strong>Deprecated.</strong> {/if} 
                        {@html fdesc(z.description)} {#if z.defaultValue} Default: {z.defaultValue} {/if}
                      </p>
                    </td>
                  </tr>
                {/each}
              {/each}
            </tbody>
          {:else}
            <p class="italic">Empty message</p>
          {/if}
        {:else if sectionName == "enums"}
          {#if item.values.length > 0}
            <thead class="{custom.table.thead}">
              <tr>
                <th scope="col" class="{custom.table.th_col}">Name</th>
                <th scope="col" class="{custom.table.th_col}">Number</th>
                <th scope="col" class="{custom.table.th_col}">Description</th>
              </tr>
            </thead>
            <tbody>
              {#each item.values as z, i}
                <tr class="{custom.table.tr}">
                  <th scope="row" class="{custom.table.th_row}">{z.name}</th>
                  <td class="{custom.table.td} font-fira">{z.number}</td>
                  <td class="{custom.table.td}">
                    <p>{@html fdesc(z.description)}</p>
                  </td>
                </tr>
              {/each}
            </tbody>
          {:else}
            <p class="italic">Empty enum</p>
          {/if}
        {:else if sectionName == "extensions"}
          <thead class="{custom.table.thead}">
            <tr>
              <th scope="col" class="{custom.table.th_col}">Extension</th>
              <th scope="col" class="{custom.table.th_col}">Type</th>
              <th scope="col" class="{custom.table.th_col}">Base</th>
              <th scope="col" class="{custom.table.th_col}">Number</th>
              <th scope="col" class="{custom.table.th_col}">Description</th>
            </tr>
          </thead>
          <tbody>
            <tr class="{custom.table.tr}">
              <th scope="row" class="{custom.table.th_row}">{item.name}</th>
              <td class="{custom.table.td} font-fira">
                <a class="{custom.table.link}" href="#{imported ? item.fullType : item.longType}">{imported ? item.fullType : item.longType}</a>
              </td>
              <td class="{custom.table.td} font-fira">
                <a class="{custom.table.link}" href="#{imported ? item.containingFullType : item.containingLongType}">{imported ? item.containingFullType : item.containingLongType}</a>
              </td>
              <td class="{custom.table.td} font-fira">{item.number}</td>
              <td class="{custom.table.td}">
                <p>{@html fdesc(item.description)} {#if item.defaultValue} Default: {item.defaultValue} {/if}</p>
              </td>
            </tr>
          </tbody>
        {/if}
      </table>
    </div>
  {/each}
{:else}
  <div class="{custom.table.caption}">
    <a class="{custom.table.link}" id="scalar-value-types" href="#scalar-value-types">Scalar Value Types</a>
  </div>
  <div class="{custom.table.container}">
    <table class="{custom.table.table}">
      <thead class="{custom.table.thead}">
        <tr>
          <th scope="col" class="{custom.table.th_col}">Proto Type</th>
          <th scope="col" class="{custom.table.th_col}">Notes</th>
          <th scope="col" class="{custom.table.th_col}">C++</th>
          <th scope="col" class="{custom.table.th_col}">Java</th>
          <th scope="col" class="{custom.table.th_col}">Python</th>
          <th scope="col" class="{custom.table.th_col}">Go</th>
          <th scope="col" class="{custom.table.th_col}">C#</th>
          <th scope="col" class="{custom.table.th_col}">PHP</th>
          <th scope="col" class="{custom.table.th_col}">Ruby</th>
        </tr>
      </thead>
      <tbody>
        {#each entry as svt}
          <tr class="{custom.table.tr}" id="{svt.protoType}">
            <td class="{custom.table.td}">{svt.protoType}</td>
            <td class="{custom.table.td}">{svt.notes}</td>
            <td class="{custom.table.td}">{svt.cppType}</td>
            <td class="{custom.table.td}">{svt.javaType}</td>
            <td class="{custom.table.td}">{svt.pythonType}</td>
            <td class="{custom.table.td}">{svt.goType}</td>
            <td class="{custom.table.td}">{svt.csType}</td>
            <td class="{custom.table.td}">{svt.phpType}</td>
            <td class="{custom.table.td}">{svt.rubyType}</td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
{/if}