# Security model and production controls

## Trust boundary

The TouristSaver API is authoritative. The SDK never decodes a token or decides
membership status itself. It merely transports the short-lived token, enforces
fail-closed browser behaviour, and acts on the API decision.

JavaScript cannot prevent a determined visitor from reading HTML that the
partner has already sent to their browser. V1 is therefore appropriate for
gating a partner landing-page journey, not for embedding secrets or protecting
privileged partner APIs.

If a future partner requires server-enforced access, use the same token and
verification contract at its edge/backend, then establish a first-party partner
session before serving protected content. The browser SDK can remain as the UX
layer.

## Required production controls

- Opaque, random, audience-bound tokens with a maximum two-minute TTL.
- Token digests at rest; never store or log raw tokens server-side.
- Active membership checked at issuance and optionally rechecked at verify.
- Exact partner-origin CORS allowlists; never wildcard CORS.
- `Cache-Control: no-store` on issue and verify responses.
- HTTPS everywhere, with HSTS on production hosts.
- Rate limits by source, partner, and token digest.
- Constant-time digest comparison.
- No member PII in the verification response.
- Partner launch and fallback URLs sourced from the registry, not user input.
- Content Security Policy that allows only the versioned SDK and required APIs.
- `Referrer-Policy: no-referrer` on the protected partner page.
- Versioned, immutable SDK assets with Subresource Integrity when CDN-hosted.
- Audit events for issuance, allow/deny reason, partner, timestamp, request ID,
  and SDK version—never the raw token.

## Browser token handling

The SDK removes `ts_token` from the address bar immediately. After successful
verification it can retain the token in `sessionStorage` for same-tab refreshes.
It never uses persistent local storage or cookies.

Partners must not forward the query string into analytics. Their analytics and
error tooling should explicitly redact `ts_token` as defence in depth.

## Failure policy

Missing, invalid, expired, mismatched, and unverifiable tokens all fail closed.
Network failures never reveal the partner page. Public messages remain generic
while detailed causes are correlated internally through `requestId`.
