import { error, json } from '@sveltejs/kit';

import yaml from 'js-yaml';

import type { Interfaces } from '$lib/interfaces';
import ifcLoad from '$lib/interfaces.yaml?raw';

const interfaces = yaml.load(ifcLoad) as Interfaces;

/** @type {import('./$types').PageLoad} */
export async function load({ url, fetch, params }) {
  const pathUrl = url.origin;
  const p = params.interface;
  const s = params.service;
  let found;

  found = Object.keys(interfaces).includes(p);
  if (found) {
    found = Object.keys(interfaces[p].services).includes(s);
    if (found) {
      let invalidKeys = [];
      for (const [key, value] of url.searchParams.entries()) {
        if (key != "version") invalidKeys.push(key);
      }
      if (invalidKeys.length > 0) throw error(404, "Invalid URL Parameters");

      let ov = Object.keys(interfaces[p].services[s].versions);
      let v = ov[0];
      if (url.searchParams.has("version")) {
        v = url.searchParams.get("version").trim();
        if (!ov.includes(v)) {
          throw error(404, "Unsupported Version");
        }
      }

      let protoDoc = "";
      let protoDocPath = `interfaces/${p}/${s}/${v}/proto-doc.json`;
      const modules = import.meta.glob('$lib/interfaces/*/*/*/*', {as: "raw", eager: true})
      for (const path in modules) {
        if(path.includes(protoDocPath)) {
          protoDoc = modules[path];
        }
      }

      if(protoDoc != "") {
        return {
          interface: p, service: s, version: v,
          protoDoc: JSON.parse(protoDoc)
        }
      } else {
        throw error(404, "Error fetching proto definition");
      }
    }
    else throw error(404, "Unsupported Service");
  } else {
    throw error(404, "Unsupported Product");
  }
}