import { error } from '@sveltejs/kit'
import interfaces from '$lib/interfaces.json'

/** @type {import('./$types').PageLoad} */
export async function load({ url, fetch, params }) {
  const pathUrl = url.origin;
  const p = params.interface;
  const s = params.service;
  let found;

  found = Object.keys(interfaces).includes(p);
  if(found) {
    found = Object.keys(interfaces[p].services).includes(s);
    if(found) {
      let invalidKeys = [];
      for (const [key, value] of url.searchParams.entries()) {
        if(key != "version") invalidKeys.push(key);
      }
      if(invalidKeys.length > 0) throw error(404, "Invalid URL Parameters");

      let ov = interfaces[p].services[s].versions;
      let v = Object.keys(ov)[0];
      if(url.searchParams.has("version")) {
        v = url.searchParams.get("version").trim()
        if(!Object.keys(ov).includes(v)) {
          throw error(404, "Unsupported Version");
        }
      }

      try {
        let response = await fetch(`${pathUrl}/interfaces/${p}/${s}/${v}/proto-doc.json`);
        return {
          interface: p, service: s, version: v,
          protoDoc: await response.json()
        };
      } catch(e) {
        throw error(404, "Error fetching proto definition");
      }
    }
    else throw error(404, "Unsupported Service");
  } else {
    throw error(404, "Unsupported Product");
  }
}