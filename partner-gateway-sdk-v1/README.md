# TouristSaver Partner Gateway SDK — Version 1

The Partner Gateway gives a strategic partner one small, consistent way to
verify that a visitor arrived with an active TouristSaver membership.

It does not manage pricing, discounts, products, bookings, payments, checkout,
partner customer accounts, or fulfilment.

## Package contents

- `TouristSaver-Partner-Gateway-SDK-V1-Developer-Review.pdf` — consolidated
  external partner developer package.
- `PARTNER_HANDOFF.md` — maintainable source for the consolidated PDF.
- `touristsaver-partner-gateway.js` — dependency-free browser SDK.
- `docs/API.md` — token issuance and verification REST contract.
- `docs/INSTALLATION.md` — production integration checklist.
- `docs/CONFIGURATION.md` — complete SDK setting reference.
- `docs/ARCHITECTURE.md` — scalable platform architecture.
- `docs/SECURITY.md` — security boundary and production controls.
- `examples/experience-oz.html` — first-partner integration example.
- `examples/test-page.html` — standalone local acceptance page.
- `examples/error-handling.html` — callbacks and browser events.
- `examples/unauthorised.html` — safe fallback landing-page example.
- `test/gateway.test.js` — automated SDK behaviour tests.
- `tools/render_pdf.swift` — repeatable macOS PDF renderer.

## Installation

Host the versioned JavaScript file on an approved TouristSaver CDN or copy it
into the partner's static assets. Include it near the top of the protected
page's `<head>`, then initialise it immediately:

```html
<script src="/assets/touristsaver-partner-gateway.v1.0.0.js"></script>
<script>
  TouristSaverGateway.init({
    partner: 'partner-slug',
    verifyEndpoint:
      'https://api.example.touristsaver/partner-gateway/verify-token',
    redirectUrl: 'https://www.example.touristsaver/partner-offers',
    unauthorisedMessage:
      'This offer is exclusively available to TouristSaver members.'
  });
</script>
```

No URL is hard-coded inside the SDK.

## Required configuration

| Setting | Purpose |
| --- | --- |
| `partner` | Registered lowercase partner slug, such as `experienceoz`. |
| `verifyEndpoint` | TouristSaver token-verification REST endpoint. Must use HTTPS. |
| `redirectUrl` | TouristSaver landing page used when access is denied. Must use HTTPS. |

## Optional configuration

| Setting | Default | Purpose |
| --- | --- | --- |
| `unauthorisedMessage` | TouristSaver member-only message | Added to the fallback redirect. |
| `tokenParameter` | `ts_token` | Query-string token name. |
| `requestTimeoutMs` | `8000` | Verification timeout, from 1–30 seconds. |
| `blockPage` | `true` | Prevents protected-page flash before verification. |
| `persistTokenInSession` | `true` | Supports refresh in the same browser tab until token expiry. |
| `includeMessageInRedirect` | `true` | Adds the configured message to the fallback URL. |
| `onAuthorised(result)` | — | Called after successful verification. |
| `onUnauthorised(result)` | — | Called immediately before fallback redirect. |

## Runtime behaviour

1. The SDK reads `ts_token` from the current URL.
2. It immediately removes the token from browser history and the address bar.
3. It posts the token and configured partner slug to TouristSaver.
4. A valid, matching response reveals the existing partner page.
5. Missing, invalid, expired, mismatched, or unverifiable tokens redirect to
   the configured TouristSaver URL.
6. A validated token is retained only in tab-scoped `sessionStorage`, allowing
   a page refresh while the short-lived token remains valid.

The redirect adds `ts_gateway_reason` and, by default,
`ts_gateway_message`. The TouristSaver landing page should render the message
using text-safe templating, never raw HTML.

## Browser events

The SDK dispatches:

- `touristsaver:authorised`
- `touristsaver:unauthorised`

See `examples/error-handling.html` for callback and event usage.

## Local acceptance test

No package installation is required. From this directory:

```bash
python3 -m http.server 8080
```

Then open:

- Valid: `http://localhost:8080/examples/test-page.html?ts_token=valid-demo-token`
- Expired: `http://localhost:8080/examples/test-page.html?ts_token=expired-demo-token`
- Invalid: `http://localhost:8080/examples/test-page.html?ts_token=anything-else`
- Missing: `http://localhost:8080/examples/test-page.html`

The test page mocks only the verification endpoint. The production example
does not mock any API.

Run automated tests with:

```bash
npm test
```

## Integration boundary

The browser SDK is an access-flow gate suitable for a partner landing page. It
cannot make already-delivered HTML or secrets cryptographically private from a
visitor who disables JavaScript. Any sensitive inventory, private pricing API,
or privileged operation must also enforce the TouristSaver grant at the
partner's server or edge. See `docs/SECURITY.md`.
