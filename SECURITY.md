# Security Policy

## Supported versions

This repository contains Aegis skill v1.1. Support and release lifecycle beyond this version have not been established.

## Reporting a vulnerability

Report privately through an owner-approved channel. Do not open a public issue or disclose sensitive details. GitHub private vulnerability reporting may be used if the owner enables it; availability is unverified. A dedicated email, PGP key and alternative contact are pending owner approval. Proposed response targets: acknowledgement in two business days, triage in five, coordinated remediation target 90 days; these are not a verified staffed SLA.

Include affected commit/version, configuration, minimal safe reproduction or conditions, impact, suggested mitigation and proposed disclosure timing. We aim to reproduce, scope and rate issues, patch with a regression test and coordinate advisory and credit. Do not test live services, access others' data, use automated production scanners or disrupt service without explicit written approval. No legal safe-harbor commitment is made until approved by the owner.

## Scope

In scope: authorized source review of this repository at a named commit. Out of scope: third-party services, production scanning, social engineering, physical access, denial of service and unauthorized data access. No production endpoint or mobile application is declared here.

## Intended controls (verify independently)

- Secrets: no committed secrets; scan source/history and client output; rotate exposed keys before remediation; never print credentials.
- Dependencies: advisory source: GitHub Advisories; cadence: weekly. Version updates weekly; security updates immediate when enabled. Security owner reviews dependency changes. Enforce lockfiles and hashes where applicable; scope private packages to their actual private registries; disable external install code where practical. Record dated advisory checks; generate SBOMs.
- CI/CD: full commit SHA pins; minimum permissions; no secrets with untrusted code; checkout without persisted credentials; protected tag and release environment; OIDC where supported.
- Data: minimize, encrypt, mask and test retention/deletion; redact logs.
- Detection: log security events, restrict access and assign alert owners.
- Recovery: immutable prior artifact, verified provenance and SBOM; dated restore/rollback drill required. RTO/RPO pending owner definition.
- Disclosure: coordinate confirmed findings and publish approved advisories where applicable.

These are policy targets, not evidence that controls are enabled. See docs/evidence.md.

## Machine-readable pointers

- security.txt: owner-approved public contact and domain required before publication; template in templates/security.txt.example.
- Advisory source: GitHub Security Advisories.
- SBOMs: release assets sbom-source.spdx.json and sbom-source.cdx.json after verification.
- Verify a downloaded archive for the exact source tag (replace TAG with the actual tag):

```sh
gh attestation verify aegis.tar.gz --repo jussray/aegis --signer-workflow jussray/aegis/.github/workflows/release.yml --source-ref refs/tags/TAG
gh attestation verify aegis.tar.gz --repo jussray/aegis --signer-workflow jussray/aegis/.github/workflows/release.yml --source-ref refs/tags/TAG --predicate-type https://cyclonedx.org/bom
gh attestation verify aegis.tar.gz --repo jussray/aegis --signer-workflow jussray/aegis/.github/workflows/release.yml --source-ref refs/tags/TAG --predicate-type https://spdx.dev/Document/v2.3
sha256sum -c SHA256SUMS
```

Container verification is not applicable until a container build exists. For rollback re-verify the previous release and restore in a designated staging system; record the date, digest and outcome.

## Contact

Repository owner: @jussray. Dedicated security contact and incident response hours are not yet confirmed.
