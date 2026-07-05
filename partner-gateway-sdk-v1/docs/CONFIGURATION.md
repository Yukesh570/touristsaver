# SDK configuration guide

```js
TouristSaverGateway.init({
  partner: 'experienceoz',
  verifyEndpoint:
    'https://api.touristsaver.org/api/partner-gateway/verify-token',
  redirectUrl: 'https://touristsaver.org/partners/experienceoz',
  unauthorisedMessage:
    'This offer is exclusively available to TouristSaver members.',
  requestTimeoutMs: 8000,
  blockPage: true,
  persistTokenInSession: true,
  includeMessageInRedirect: true
});
```

## Required settings

### `partner`

The registered partner audience. Use only the slug supplied by TouristSaver.
It is lowercase, 2–64 characters, and may contain letters, numbers, `_`, or
`-`. A token issued for one slug cannot authorise another.

### `verifyEndpoint`

The TouristSaver REST endpoint. Production endpoints must use HTTPS. The SDK
posts JSON and sends no browser credentials or referrer.

### `redirectUrl`

The TouristSaver page used for denied access. It receives:

- `ts_gateway_reason`
- `ts_gateway_message` unless disabled

## Optional settings

### `unauthorisedMessage`

Public fallback text. Do not include internal errors or member information.

### `tokenParameter`

Defaults to `ts_token`. Change it only when agreed with TouristSaver.

### `requestTimeoutMs`

Defaults to 8000 milliseconds. Accepted range: 1000–30000.

### `blockPage`

Defaults to `true`. It prevents a visual flash of the partner page before the
access decision. Disabling it weakens the intended experience and is not
recommended for production.

### `persistTokenInSession`

Defaults to `true`. The raw short-lived token is retained in tab-scoped
`sessionStorage` only after successful verification. It is revalidated on
refresh and removed after denial.

### `includeMessageInRedirect`

Defaults to `true`. Disable only if the fallback landing page supplies its own
fixed message.

### `onAuthorised(result)` / `onUnauthorised(result)`

Optional operational callbacks. Results contain partner, reason/expiry, and
request ID only. They never contain the token or member PII.

## Configuration errors

`init()` rejects its Promise for integration mistakes such as missing URLs,
non-HTTPS production endpoints, malformed partner slugs, or invalid timeouts.
The page remains blocked by default. Catch and report these errors to partner
monitoring without exposing page content.
