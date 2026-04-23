---
name: api-design
description: Skill for designing APIs (REST, GraphQL, gRPC). Apply these rules when designing, implementing, or reviewing HTTP APIs.
---

# API Design Principles

Use this skill whenever designing, implementing, or reviewing APIs.

## Core Principles

- Design APIs for the consumer, not the implementation.
- Prefer simplicity and consistency over flexibility and cleverness.
- Make the API hard to misuse; make correct usage obvious.
- Treat API contracts as public commitments; design for longevity.
- Be consistent within the API surface; do not mix conventions.
- Optimize for the common case; support the advanced case without penalizing the simple one.

## REST API Design

### Resource Naming

- Use nouns for resource names, not verbs: `/users`, `/orders`, not `/getUsers`, `/createOrder`.
- Use plural nouns for collections: `/users`, `/orders`, `/invoices`.
- Use kebab-case for multi-word paths: `/order-items`, `/user-profiles`.
- Use snake_case for query parameters and JSON fields: `first_name`, `created_at`, `page_size`.
- Nest resources to express ownership: `/users/{user_id}/orders/{order_id}`.
- Limit nesting to two levels; use top-level resources with filters for deeper relationships.
- Use path parameters for identity (`/users/{id}`); use query parameters for filtering, sorting, pagination.

```
# Good
GET    /users
GET    /users/{id}
POST   /users
PUT    /users/{id}
PATCH  /users/{id}
DELETE /users/{id}
GET    /users/{id}/orders

# Bad
GET    /getUsers
POST   /createUser
GET    /users/{id}/orders/{order_id}/items/{item_id}/details
```

### HTTP Methods

- `GET` — Read (safe, idempotent, cacheable). Never use for mutations.
- `POST` — Create resource or trigger action. Not idempotent.
- `PUT` — Full replacement of a resource. Idempotent.
- `PATCH` — Partial update. Use JSON Merge Patch (RFC 7396) or JSON Patch (RFC 6902).
- `DELETE` — Remove resource. Idempotent. Return `204 No Content`.
- Use `POST` for actions that don't map to CRUD: `POST /orders/{id}/cancel`.

### Status Codes

Use the correct HTTP status code for every response:

- `200 OK` — Successful GET, PUT, PATCH with body.
- `201 Created` — Successful POST that creates a resource. Include `Location` header.
- `204 No Content` — Successful DELETE or PUT/PATCH with no response body.
- `400 Bad Request` — Malformed request syntax or invalid parameters.
- `401 Unauthorized` — Missing or invalid authentication.
- `403 Forbidden` — Authenticated but not authorized.
- `404 Not Found` — Resource does not exist.
- `409 Conflict` — State conflict (e.g., duplicate creation, version mismatch).
- `422 Unprocessable Entity` — Validation errors on well-formed input.
- `429 Too Many Requests` — Rate limit exceeded. Include `Retry-After` header.
- `500 Internal Server Error` — Unhandled server failure.

### Request and Response Format

- Use JSON as the default format; use `Content-Type: application/json`.
- Use consistent envelope structure or return bare resources — pick one and maintain it.
- Use ISO 8601 for dates and times with timezone (`2026-03-24T10:30:00Z`).
- Use UTC for all timestamps.
- Use string representation for IDs (even numeric ones) to avoid precision issues.
- Return the created/updated resource in the response body for `POST`, `PUT`, `PATCH`.
- Include `self` links in responses when practical.

```json
{
  "id": "usr_abc123",
  "name": "Alice",
  "email": "alice@example.com",
  "created_at": "2026-03-24T10:30:00Z",
  "updated_at": "2026-03-24T10:30:00Z"
}
```

### Error Responses

- Use a consistent error format across all endpoints.
- Include a machine-readable `code`, a human-readable `message`, and optional `details` array.
- Use RFC 7807 Problem Details format when the API ecosystem supports it.

```json
{
  "code": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "details": [
    { "field": "email", "message": "must be a valid email address" },
    { "field": "name", "message": "is required" }
  ]
}
```

### Pagination

- Use cursor-based pagination for large, dynamic datasets. Include `cursor`, `limit`, and `next_cursor` in the response.
- Use offset-based pagination (`page`, `page_size`) only for stable, small datasets.
- Always return pagination metadata: `total_count` (when practical), `has_more`, `next_cursor`.

```json
{
  "data": [ ... ],
  "pagination": {
    "next_cursor": "eyJpZCI6MTAwfQ==",
    "has_more": true,
    "total_count": 1432
  }
}
```

### Filtering, Sorting, and Search

- Use query parameters for filtering: `GET /users?role=admin&status=active`.
- Use `sort` parameter with field names and direction: `?sort=created_at:desc,name:asc`.
- Use `q` or `search` for full-text search: `?q=alice`.
- Use `fields` parameter for sparse fieldsets when response payloads are large.

### Versioning

- Use URL path versioning (`/v1/users`) for major versions.
- Use additive, backward-compatible changes for minor evolution (new optional fields, new endpoints).
- Never remove or rename fields in a version; deprecate and add new ones.
- Communicate deprecations with `Sunset` and `Deprecation` headers.

### Idempotency

- Support idempotency keys (`Idempotency-Key` header) for `POST` requests that create resources or trigger actions.
- `PUT` and `DELETE` should be naturally idempotent.
- Store idempotency keys server-side with a TTL; return cached responses for duplicate requests.

## Authentication and Security

- Use OAuth 2.0 / OpenID Connect for authentication; use short-lived access tokens with refresh tokens.
- Use API keys only for server-to-server communication; never expose in client-side code.
- Use HTTPS exclusively; reject HTTP requests.
- Validate and sanitize all input at the API boundary.
- Use rate limiting with `429` responses and `Retry-After` headers.
- Use CORS with explicit allowed origins; never use `*` in production.
- Do not expose internal IDs, stack traces, or implementation details in error responses.
- Return consistent response times regardless of whether a resource exists (prevent enumeration attacks).

## API Documentation

- Use OpenAPI 3.1 (Swagger) for REST API documentation.
- Document every endpoint with description, parameters, request/response schemas, and example values.
- Include authentication requirements on each endpoint.
- Document error responses with all possible status codes and error formats.
- Keep documentation in sync with implementation; generate from code annotations or schemas when possible.

## When Designing APIs

- Start with the consumer use cases, not the data model.
- Design the URL structure and resource hierarchy first, then the request/response shapes.
- Write example requests and responses before implementing.
- Use OpenAPI spec as a contract before coding.
- Apply consistent naming, error handling, and pagination across all endpoints.
- Review the API from the perspective of a developer seeing it for the first time.
