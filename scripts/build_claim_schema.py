#!/usr/bin/env python3
"""Build published claim schemas for every publishable unit in a module repo.

A repo may hold a root module plus nested modules under modules/<name>/. Each unit
that is BU-claimable carries its own claim-schema.yaml beside its own variables.tf,
and each produces one JSON Schema in the catalog.

Nested units share the repo's single version tag — the registry publishes one
version per repo, and `//modules/<name>` selects a directory inside it. The emitted
schema records the subpath so the catalog guard can assert every claim sourced from
one repo pins the same version.

Guardrail: a non-virtual exposed field that does not exist in the unit's own
variables.tf is a hard error.
"""
import hashlib
import json
import pathlib
import sys

import hcl2
import yaml

TYPE_MAP = {"integer": "integer", "number": "number", "boolean": "boolean",
            "string": "string", "array": "array", "object": "object"}


def full_vars(unit_dir: pathlib.Path) -> dict:
    out = {}
    vf = unit_dir / "variables.tf"
    if not vf.exists():
        sys.exit(f"ERROR: {unit_dir} has claim-schema.yaml but no variables.tf")
    with open(vf) as f:
        for block in hcl2.load(f).get("variable", []):
            for name, body in block.items():
                out[name.strip('"')] = {
                    "type": str(body.get("type", "")),
                    "description": str(body.get("description", "")).strip('"'),
                    "has_default": "default" in body,
                }
    return out


def discover(repo: pathlib.Path) -> list[tuple[pathlib.Path, str]]:
    """Return (unit_dir, registry_subpath) for every claimable unit, root first."""
    units = []
    if (repo / "claim-schema.yaml").exists():
        units.append((repo, ""))
    for overlay in sorted(repo.glob("modules/*/claim-schema.yaml")):
        unit = overlay.parent
        units.append((unit, f"modules/{unit.name}"))
    return units


def build(unit_dir: pathlib.Path, subpath: str):
    overlay = yaml.safe_load((unit_dir / "claim-schema.yaml").read_text())
    variables = full_vars(unit_dir)
    props, required = {}, []
    for field, spec in overlay["exposed"].items():
        if not spec.get("virtual") and field not in variables:
            sys.exit(
                f"ERROR: {unit_dir}: exposed field '{field}' not found in "
                f"{unit_dir.name}/variables.tf"
            )
        declared = spec.get("type", "string")
        p = {"type": TYPE_MAP.get(declared, declared)}
        for k in ("enum", "pattern", "default", "description"):
            if k in spec:
                p[k] = spec[k]
        if spec.get("virtual"):
            p["x-virtual"] = True
        props[field] = p
        if spec.get("required"):
            required.append(field)

    mod = overlay["module"]
    ver = overlay["claim_version"]
    return overlay, {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "$id": f"claim-schemas/{mod}/{ver}.json",
        "title": f"{mod} claim ({ver})",
        "type": "object",
        "properties": {
            "type": {"const": mod},
            "claimSchema": {"const": f"{mod}/{ver}"},
            **props,
        },
        "required": ["type", "claimSchema", *required],
        "additionalProperties": False,
        "x-module": {
            "name": mod,
            "registry_subpath": subpath,
            "internal_variable_count": len(variables),
            "exposed_count": len(props),
        },
    }


if __name__ == "__main__":
    repo, out_dir = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
    units = discover(repo)
    if not units:
        sys.exit(f"ERROR: no claim-schema.yaml found in {repo} or {repo}/modules/*/")
    for unit_dir, subpath in units:
        overlay, schema = build(unit_dir, subpath)
        dest = out_dir / overlay["module"]
        dest.mkdir(parents=True, exist_ok=True)
        path = dest / f"{overlay['claim_version']}.json"
        path.write_text(json.dumps(schema, indent=2) + "\n")
        where = subpath or "(root)"
        print(f"published {path} from {where} "
              f"sha256={hashlib.sha256(path.read_bytes()).hexdigest()[:12]}")
