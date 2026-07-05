# Partner Gateway V1 architecture

## Components

```text
TouristSaver member app
  -> authenticated token-issuance API
  -> short-lived partner launch URL
  -> partner landing page + browser SDK
  -> central verification API
  -> allow existing page OR redirect to TouristSaver
```

## Responsibility split

TouristSaver owns member authentication, active-membership verification,
partner registration, token issuance, token verification, and the secure
handoff decision.

The partner owns its website, catalogue, prices, booking journey, checkout,
customer support, and fulfilment. The gateway neither reads nor changes those
systems.

## Generic partner onboarding

Adding partner 2 or partner 100 is a registry operation:

1. Create partner record and slug.
2. Register launch URL, fallback URL, and allowed origins.
3. Activate sandbox credentials/origins.
4. Complete the common acceptance suite.
5. Activate production.

No partner-specific branch belongs in the SDK or verification service.

## Recommended backend services

- Partner registry in the primary database.
- Token issuance service behind member authentication.
- Redis-compatible short-TTL token-digest store.
- Stateless verification API instances behind a load balancer.
- Rate limiter and exact-origin CORS middleware.
- Privacy-minimised audit/metrics pipeline.

This separates high-volume verification from the core membership database while
retaining membership as the authoritative source at issuance.

## Evolution path

V1 deliberately keeps the contract small. Later versions can add partner
server/edge verification, signed first-party partner sessions, webhooks,
entitlement scopes, or richer reporting without adding booking or pricing logic
to the gateway.
