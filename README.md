# Aegis

Defensive, owner-authorized security review, hardening and incident triage. Start with [skill v1](skill%20v1) and [invocation](invocation); use the [preflight supplement](docs/preflight.md) and [Domain 5/10 evidence procedure](docs/evidence.md). See [security policy](SECURITY.md).

This repository ships a Markdown skill, not a running service or container. Dependabot is the primary updater; additional ecosystem and Renovate examples are inactive. Release workflows build a source archive once, generate SBOMs from those bytes, attest and verify before publication. Repository settings and runtime evidence remain separate gates.

## Version registry

See [Aegis version records](registry/aegis.json). [Version 1.0](archive/aegis-v1.0.md) preserves the supplied JSC-022 historical record; [version 1.1](skill%20v1) remains the canonical definition. Historical records are archival only and confer no execution authorization. Preserve separate versions rather than overwriting them.
