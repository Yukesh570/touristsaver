# Partner Gateway REST API contract — V1

The browser SDK uses the verification endpoint. The authenticated TouristSaver
member app uses the issuance endpoint before opening a partner URL.

All responses must include `Cache-Control: no-store` and a non-sensitive
`requestId`. Tokens and member identifiers must never be written to application
logs, analytics URLs, or error-monitoring breadcrumbs.

## 1. Issue a partner hand-off token

```http
POST /api/partner-gateway/token
Authorization: Bearer <member-access-token>
Content-Type: application/json
```

Request:

```json
{
  "partner": "experienceoz"
}
```

Successful response (`201 Created`):

```json
{
  "token": "pg_opaque_random_value",
  "partner": "experienceoz",
  "expiresAt": "2026-07-05T04:32:00Z",
  "launchUrl": "https://touristsaver.experienceoz.com.au/?ts_token=pg_opaque_random_value",
  "requestId": "pgreq_01JZ..."
}
```

The server must:

1. Authenticate the member.
2. Confirm the membership is active at issuance time.
3. Confirm the partner is active.
4. Generate at least 128 bits of cryptographically secure randomness.
5. Store only a SHA-256 token digest with partner audience and a short TTL
   (recommended: 120 seconds).
6. Build `launchUrl` from the server-side partner registry, never from an
   arbitrary client-supplied redirect URL.

Failure examples:

```json
{
  "error": "membership_inactive",
  "message": "An active TouristSaver membership is required.",
  "requestId": "pgreq_01JZ..."
}
```

Use `401` for an unauthenticated member, `403` for an inactive membership or
partner, `404` for an unknown partner, and `429` for rate limiting.

## 2. Verify a hand-off token

```http
POST /api/partner-gateway/verify-token
Content-Type: application/json
X-TouristSaver-Gateway-Version: 1.0.0
Origin: https://touristsaver.experienceoz.com.au
```

Request:

```json
{
  "token": "pg_opaque_random_value",
  "partner": "experienceoz",
  "sdkVersion": "1.0.0"
}
```

Valid response (`200 OK`):

```json
{
  "valid": true,
  "partner": "experienceoz",
  "expiresAt": "2026-07-05T04:32:00Z",
  "requestId": "pgreq_01JZ..."
}
```

Invalid or expired responses are also `200 OK`, because they are expected
access decisions rather than transport failures:

```json
{
  "valid": false,
  "reason": "expired_token",
  "requestId": "pgreq_01JZ..."
}
```

Allowed reasons:

- `invalid_token`
- `expired_token`
- `partner_mismatch`
- `partner_inactive`
- `membership_inactive`

The endpoint must return `400` for malformed JSON, `429` for throttling, and
`503` when verification infrastructure is unavailable. The SDK treats any
non-2xx transport response as `verification_unavailable` and fails closed.

## CORS policy

The API must look up the configured partner and return an exact registered
origin in `Access-Control-Allow-Origin`. Never use `*` for this endpoint.

Example preflight response:

```http
Access-Control-Allow-Origin: https://touristsaver.experienceoz.com.au
Access-Control-Allow-Methods: POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-TouristSaver-Gateway-Version
Vary: Origin
```

Reject requests whose `Origin` is not registered for the supplied partner.

## Partner registry

The backend should maintain one generic registry, not partner-specific code:

| Field | Purpose |
| --- | --- |
| `slug` | Stable audience identifier used by the app, token, and SDK. |
| `active` | Emergency and commercial access switch. |
| `launch_url` | Approved protected partner URL. |
| `allowed_origins` | Exact browser origins allowed to verify. |
| `fallback_url` | TouristSaver landing page for denied access. |
| `token_ttl_seconds` | Partner policy within the platform maximum. |
| `display_name` | Reporting and operations label. |

## Privacy-minimised response

V1 verification returns only an access decision, partner, expiry, and request
ID. It does not return member name, email, phone, internal member ID, membership
purchase details, or discount information.

## Idempotency and replay

The same token may be revalidated from the same registered partner origin until
its short expiry so a same-tab refresh works. A token is audience-bound and
must never validate for another partner. Record suspicious cross-origin or
cross-partner attempts without recording the raw token.
