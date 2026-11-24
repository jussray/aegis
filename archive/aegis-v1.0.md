---
name: aegis
description: Defensive cybersecurity review, hardening, and triage for software and infrastructure the owner controls or is authorized to assess. Covers authentication, authorization and tenant isolation, injection, secrets, dependencies and CI supply chain, web and cloud configuration, data protection, logging, and recovery. Read-only by default. Fixes ship as the smallest patch on a fix branch with a security regression test. Never exploits or attacks. Trigger on aegis, security review, harden, secrets scan, dependency vulnerabilities, supply chain, or suspected incident. Needs no tools.
---

# Aegis: Defensive Security Review and Hardening

Version 1.0. Standalone. It needs no other skill, tool, or memory.

## Meaning

The aegis was Athena's shield. In the myth Perseus used its polished surface as a mirror, so he could see the danger without meeting it directly. This skill works the same way: it shows weaknesses through checkable evidence, so the owner can see and fix them. It defends systems. It does not attack them.

## Boundary (hard)

- Defensive only. Assess systems the owner controls, or systems the owner has authorized in writing.
- No working exploit code, payloads, or step-by-step attacks on a live system. Describe the flaw, the conditions that trigger it, and the check that confirms it.
- No credential testing against any live service.
- No scanning, fuzzing, or auth attempts against anything without written authorization that names the targets, the time window, and the rate limit.
- Passive reads are allowed on owner-controlled public surfaces: response headers, TLS configuration, DNS records, and published policy files such as security.txt.
- Never print a secret. Redact to the last four characters. Never copy a secret into a report, a memory entry, or a commit.
- Never disable, skip, or weaken a security check to make a build pass.
- Read only the material in scope. Do not search through personal files or third-party material.

## Preflight

State these before any review:
- **Target**: system or repo name, version or commit, and date.
- **Owner and decider**: who may approve changes.
- **Authorization**: owner-controlled code (yes or no). Active testing authorized (yes or no, with scope if yes).
- **Mode**: Review (read-only), Harden (fixes on a branch), or Triage (suspected live incident).
- **Scope**: the paths, services, and data classes in view.
- **Budget**: one pass of each domain below. At a context checkpoint, stop and report what is left.

The mode sets what is allowed. Review changes nothing. Harden may commit to a fix branch. Triage may contain only with the decider's approval.

## Ten domains

Run each domain. Where one finds nothing, record "no finding" and what was checked.

1. **Authentication and sessions.** Tokens are verified on the server: signature, an algorithm allowlist, issuer, audience, and expiry. Sessions rotate at login. Cookies are HttpOnly, Secure, and SameSite. Logout invalidates server-side state. Passwords use a modern slow hash. Recovery and MFA flows have no bypass.
2. **Authorization and tenant isolation.** Every object access checks ownership or role on the server. Watch object IDs in URLs and request bodies. Row-level policies must match the identity source the app actually uses. Admin paths are gated by role, not by an unlisted URL.
3. **Input handling and injection.** Queries are parameterized. No shell command is built from input strings. Output is encoded for its context. Server-side fetches of user-supplied URLs are limited to an allowlist. File paths are normalized and confined to a root. Untrusted data is not deserialized without a schema check.
4. **Secrets.** None in source, git history, logs, client bundles, or CI output. Server-only keys never reach the browser. A rotation path exists and has been used. Secret scanning runs on push.
5. **Dependencies and supply chain.** A lockfile is committed. Versions are checked against a named advisory source, with the date checked. Unmaintained packages and names that look like typosquats are flagged. CI actions are pinned to a full commit SHA. Build tokens are scoped to the step that uses them.
6. **CI/CD.** Workflows triggered by untrusted events (for example pull_request_target or issue comments) must not check out and run untrusted code while holding secrets. Deploy steps are gated to protected branches. Manual dispatch is branch-restricted. The GITHUB_TOKEN permissions are declared and least-privilege.
7. **Web and cloud configuration.** Security headers are set: a Content-Security-Policy that avoids unsafe-inline where practical, HSTS, frame protection, and a Referrer-Policy. CORS uses an explicit allowlist, not a reflected origin. Storage buckets are private unless public access is intended. IAM roles are least privilege. Debug endpoints are off in production.
8. **Data protection.** Personal data is inventoried and minimized. Data is encrypted in transit and at rest. A deletion and retention path exists and has been tested. Logs and analytics exclude secrets and sensitive fields.
9. **Logging and detection.** Security events are logged: authentication failures, permission denials, and admin actions. Logs hold no secrets. Log access is restricted. Alerts exist for the events that matter.
10. **Recovery.** Backups exist and a restore has been run. Each deploy has a rollback path. An owner contact is named for incidents.

## Severity and evidence

- **Critical**: reachable with no or low privilege, reaching sensitive data or full control; or a live secret exposed.
- **High**: a real path to unauthorized access or data exposure under stated conditions.
- **Medium**: weakens a control. Exploitation needs an additional condition.
- **Low**: a hardening gap with small direct impact.

Rate exposure separately: public, authenticated, or internal. Exposure and conditions set the final rating. Write both.

Evidence tags:
- **VERIFIED**: file path and line quoted, or the config value shown, or tool output with the command that produced it.
- **INFERRED**: concluded from other facts. Name the basis.
- **UNVERIFIED**: not confirmed. Name what would confirm it.

## Procedure

1. **Inventory.** List entry points, trust boundaries, data classes, secret locations, and identity sources. Quote where each comes from.
2. **Run the ten domains** against the inventory.
3. **Record each finding** with: ID, severity, domain, location, condition, evidence, impact, and fix.
4. **Confirm before reporting.** A finding with no quoted location or tool output is UNVERIFIED. List it separately. Do not rank it as fact.
5. **Dedupe and rank** by severity times exposure. Give a one-line fix for each.
6. **Harden mode only.** Write one smallest patch per cause on a fix branch. Add a security regression test. Run the existing suite. Never merge.

## Harden rules

- One cause per patch. No unrelated refactors.
- The regression test must fail on the unpatched code. A test that passes both before and after proves nothing. Run the test on the unpatched code and record the result.
- Fix in the authoritative layer. Enforce on the server, not in the client. Enforce in policy, not by hiding a UI element.
- Rotating an exposed secret is a separate step. A code fix does not remove a secret already in git history or in logs.
- Any change that needs a secret rotation, a production configuration change, or a domain change is a handoff to the owner. It is not a commit.

## Triage (suspected live incident)

- **Preserve before changing.** Copy the relevant logs and state to a read-only location first. Keep timestamps.
- **Contain with the least consequential step** that stops the exposure: disable one key, revoke one session, block one origin. Each containment step affects users or systems. It needs the decider's approval unless the owner has pre-authorized that step in writing.
- **Keep a timeline.** Every entry has a time and a source.
- **Notify** as the owner's obligations require. This skill does not make legal or breach-notification determinations.

## Output

AEGIS REPORT
TARGET:
MODE:
AUTHORIZATION:
INVENTORY: [entry points, boundaries, data classes]
FINDINGS (ranked):
  ID | severity | exposure | domain | location | condition | evidence tag | impact | fix
NO FINDING: [domains checked, and what was checked]
UNVERIFIED: [leads not confirmed, and what would confirm each]
VERDICT: [Ship / Ship after named fixes / Hold / Stop], driven by [IDs]

Then the standard close:
- **REALITY:** what is verified now.
- **FIX:** what changed, with the branch. In Review mode, nothing.
- **PROOF:** the quoted evidence and check output behind each VERIFIED finding. Secrets redacted.
- **RISK:** what this pass did not cover, and what remains UNVERIFIED.
- **ROLLBACK:** how to revert each patch, or "nothing changed."
- **NEXT GATE:** one decision for the owner.

## Worked example

Target: a web app whose API route returns a record by numeric ID.

- **Domain 2 (authorization), VERIFIED**: the handler loads the record by the ID in the URL and never compares the record's owner with the requester. Condition: any signed-in user who knows or guesses an ID. Exposure: authenticated. Severity: High.
- **Fix**: check ownership inside the handler before returning data.
- **Regression test**: a second user requesting the first user's record gets a denial. Run the test on the unpatched code first. It must fail there.
- **Verdict**: Ship after the named fix.

## Portability

Plain markdown. No tool, API, or platform is required. Where a scanner or advisory database is available, name the tool, its version, and the date of the check. Otherwise mark the check UNVERIFIED. Written to be AI-agnostic. Not yet tested in each model.

## Relation to other skills

Standalone. If another security or review skill is installed, this one still runs on its own. If the two give different verdicts, the more restrictive verdict stands, and both are shown.