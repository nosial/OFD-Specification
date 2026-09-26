# Open Federated Database (OFD) Specification

This repository houses the official build system and source documentation for the
Open Federated Database Specification. The specification is authored as a single
Bikeshed source document and rendered to a standalone HTML document by the
integrated build system.

## What is this?

The Open Federated Database (OFD) is a specification for self-hosted network
services designed to mitigate spam and malicious activity without compromising
user privacy or introducing friction to the digital landscape.

The specification outlines a semi-decentralized framework for identifying
entities and actors across federated databases. By adhering to this common
standard, firewalls, clients, servers, and automated services can reliably
detect malicious content or behavior and take proactive measures to prevent abuse.

Adopters of the specification retain full autonomy over how they respond to
database queries; the federated database itself is strictly responsible for
indexing entries, maintaining historical context, and providing standardized
telemetry to assist in risk assessment.

While any individual OFD host can define what constitutes malicious behavior
within their domain, the framework is primarily tailored to target malware and
spam. Hosts are free to categorize content using custom tags, allowing downstream
consumers to select the specific database providers that align with their security
and threat-modeling requirements.

## Building

The specification is authored in [Bikeshed](https://bikeshed.spec.whatwg.org/)
as a single source document (`index.bs`) and rendered to a standalone HTML
document (`index.html`).

Requirements: Python 3 and [pipx](https://pipx.pypa.io/).

```sh
make update          # first time only: download Bikeshed specification data
make spec            # build index.bs -> index.html
make watch           # rebuild automatically on every change
make check           # strict build; fails on any warning or error
make serve           # serve the built spec at http://127.0.0.1:8000/
```

Every push is validated and built automatically by GitHub Actions; publishing a
release also deploys the rendered specification to GitHub Pages and attaches it
to the release.

## Repository layout

- `index.bs` — the specification source (Bikeshed)
- `Makefile` — build targets (`make help` for a full list)
- `.github/workflows/` — CI: build, validation, and release deployment

## Contributing

To contribute to the standard, please submit a pull request against the `dev` 
branch. To ensure the specification remains equitable and balanced for all 
participants, contributions must adhere to a strict set of foundational rules and 
conditions.

While these guidelines may evolve over time, the core principle remains absolute:
preserve and respect user privacy while engineering effective solutions to combat
malicious actors. Detailed contribution requirements will be documented in this
section as they are finalized.

## License

Copyright (C) 2022-2026 Nosial

This project is licensed under the GNU General Public License. The full text of the license can be found in the accompanying [`LICENSE`](LICENSE) file.

### Why the GPL?

The GPL ensures that the specification remains open, free, and accessible to
everyone in perpetuity. Even if a commercial entity adapts the specification for
proprietary or monetized implementations, the underlying standard remains
protected. True technical freedom ensures that all participants regardless of
size have equal access to the same foundational technologies.