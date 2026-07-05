# Installation guide

## TouristSaver preparation

Before a partner begins development, TouristSaver registers:

1. A stable partner slug.
2. The exact protected launch URL.
3. Every permitted production and test origin.
4. The TouristSaver fallback landing page.
5. Token TTL and partner active status.

TouristSaver then supplies the partner with:

- The versioned SDK file or approved CDN URL.
- The registered partner slug.
- The production and sandbox verification endpoints.
- The expected fallback URL and acceptance-test links.

## Partner installation

1. Place `touristsaver-partner-gateway.js` in a versioned static asset path.
2. Add `Referrer-Policy: no-referrer` to the protected page response, or use the
   equivalent `<meta name="referrer" content="no-referrer">` tag.
3. Include and initialise the SDK at the top of `<head>`, before partner page
   content is parsed.
4. Use the exact configuration values supplied by TouristSaver.
5. Ensure the page Content Security Policy permits the SDK and verification
   endpoint.
6. Redact `ts_token` in analytics, reverse-proxy logs, and error tooling.
7. Test every acceptance case below.

## Acceptance checklist

- Valid token reveals the unchanged partner page.
- Missing token redirects to TouristSaver.
- Invalid token redirects to TouristSaver.
- Expired token redirects to TouristSaver.
- A token issued for another partner is rejected.
- Verification timeout/network failure redirects to TouristSaver.
- The token disappears from the address bar immediately.
- A same-tab refresh revalidates while the token remains unexpired.
- No product, price, booking, checkout, or fulfilment behaviour changes.
- Browser console and analytics contain no token or member PII.

## Release checklist

- Pin a specific SDK version; never use an unversioned “latest” URL.
- Verify the production origin is present in TouristSaver's partner registry.
- Verify fallback message rendering uses `textContent` or escaped templates.
- Confirm HTTPS and HSTS on both TouristSaver and partner hosts.
- Confirm monitoring distinguishes allow, deny, timeout, and configuration
  errors without recording raw tokens.
