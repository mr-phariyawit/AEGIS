---
name: api-docs
description: "API documentation generator — auto-generates OpenAPI/Swagger specs from code, creates SDK usage examples, and maintains living API docs. Use this skill whenever the user mentions API documentation, Swagger, OpenAPI, API spec, endpoint docs, 'document this API', 'generate API docs', 'create API reference', REST docs, GraphQL schema docs, SDK examples, API changelog, or any request to create, update, or validate API documentation. Also triggers on 'สร้าง API doc', 'เขียนเอกสาร API', 'ทำ Swagger'. Supports REST, GraphQL, and WebSocket APIs. Detects drift between docs and implementation."
---

# API Documentation Generator

Auto-generate and maintain API documentation from code, ensuring docs always reflect the actual implementation.

## Core Principle

> "If the docs are wrong, the API is wrong."

Documentation drift is the #1 cause of integration failures. This skill keeps docs synchronized with code by generating from source and detecting discrepancies.

## Capabilities

### 1. Generate OpenAPI Spec from Code

Analyze route handlers, controllers, and types to produce OpenAPI 3.1 YAML/JSON:

**Input sources to scan:**
- Express/Fastify/Hono route definitions
- Zod/Joi/Yup validation schemas → request/response types
- TypeScript interfaces/types → schema definitions
- JSDoc/TSDoc comments → descriptions
- Python FastAPI/Flask route decorators
- Pydantic models → schema definitions

**Output — openapi.yaml:**

```yaml
openapi: 3.1.0
info:
  title: [Project] API
  version: 1.0.0
  description: |
    API documentation auto-generated from source code.
    Last synced: [date]

servers:
  - url: https://api.example.com/v1
    description: Production
  - url: https://staging-api.example.com/v1
    description: Staging
  - url: http://localhost:3000/v1
    description: Local Development

paths:
  /users:
    get:
      summary: List users
      operationId: listUsers
      tags: [Users]
      security:
        - bearerAuth: []
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
            minimum: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
            maximum: 100
      responses:
        '200':
          description: Paginated list of users
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PaginatedUsers'
        '401':
          $ref: '#/components/responses/Unauthorized'

    post:
      summary: Create user
      operationId: createUser
      tags: [Users]
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
            example:
              email: "user@example.com"
              name: "John Doe"
              role: "member"
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '400':
          $ref: '#/components/responses/ValidationError'
        '409':
          description: Email already exists

components:
  schemas:
    User:
      type: object
      required: [id, email, name, role, createdAt]
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 1
          maxLength: 100
        role:
          type: string
          enum: [admin, member, viewer]
        createdAt:
          type: string
          format: date-time

    CreateUserRequest:
      type: object
      required: [email, name]
      properties:
        email:
          type: string
          format: email
        name:
          type: string
        role:
          type: string
          enum: [admin, member, viewer]
          default: member

    PaginatedUsers:
      type: object
      properties:
        data:
          type: array
          items:
            $ref: '#/components/schemas/User'
        pagination:
          $ref: '#/components/schemas/Pagination'

    Pagination:
      type: object
      properties:
        page:
          type: integer
        limit:
          type: integer
        total:
          type: integer
        totalPages:
          type: integer

  responses:
    Unauthorized:
      description: Missing or invalid authentication token
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    ValidationError:
      description: Request validation failed
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'

  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
```

### 2. Generate Markdown API Reference

Convert OpenAPI spec (or raw code) into readable Markdown:

```markdown
# API Reference

## Authentication

All endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer <your-jwt-token>
```

## Users

### List Users
`GET /v1/users`

Returns a paginated list of users.

**Query Parameters:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | integer | 1 | Page number (min: 1) |
| limit | integer | 20 | Items per page (max: 100) |

**Response 200:**
```json
{
  "data": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "user@example.com",
      "name": "John Doe",
      "role": "member",
      "createdAt": "2026-03-17T10:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

**Errors:**
| Status | Description |
|--------|-------------|
| 401 | Missing or invalid auth token |
| 403 | Insufficient permissions |
```

### 3. Generate SDK Usage Examples

For each endpoint, generate copy-paste ready examples:

**TypeScript (fetch):**
```typescript
const response = await fetch('https://api.example.com/v1/users', {
  headers: { 'Authorization': `Bearer ${token}` },
});
const { data, pagination } = await response.json();
```

**Python (httpx):**
```python
async with httpx.AsyncClient() as client:
    response = await client.get(
        "https://api.example.com/v1/users",
        headers={"Authorization": f"Bearer {token}"},
    )
    data = response.json()
```

**cURL:**
```bash
curl -X GET https://api.example.com/v1/users \
  -H "Authorization: Bearer $TOKEN"
```

### 4. Drift Detection

Compare existing docs against current code to find discrepancies:

```markdown
# API Documentation Drift Report

## Discrepancies Found: 5

### 🔴 Missing from Docs
- `DELETE /v1/users/:id` — endpoint exists in code but not documented
- `PATCH /v1/users/:id/role` — new endpoint added in commit abc123

### 🟡 Docs Outdated  
- `POST /v1/users` — docs show `username` field but code expects `name`
- `GET /v1/users` — docs missing `search` query parameter

### 🔵 Docs-only (no matching code)
- `PUT /v1/users/:id/avatar` — documented but endpoint removed in commit def456

## Recommended Actions
1. Add docs for DELETE and PATCH endpoints
2. Update POST /v1/users field names
3. Remove PUT avatar docs or restore endpoint
```

### 5. API Changelog

Track API changes across versions:

```markdown
# API Changelog

## v1.3.0 (2026-03-17)
### Added
- `PATCH /v1/users/:id/role` — Update user role (admin only)
- `search` query parameter on `GET /v1/users`

### Changed
- `POST /v1/users` — `username` field renamed to `name`

### Deprecated
- `GET /v1/users?name=X` — Use `search` parameter instead. Removal in v2.0.

### Removed
- `PUT /v1/users/:id/avatar` — Use dedicated media service
```

## Error Response Standards

Define consistent error format across all endpoints:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format",
        "value": "not-an-email"
      }
    ],
    "requestId": "req_abc123",
    "timestamp": "2026-03-17T10:30:00Z"
  }
}
```

Standard error codes to document:
- `UNAUTHORIZED` (401) — Missing/invalid token
- `FORBIDDEN` (403) — Insufficient permissions
- `NOT_FOUND` (404) — Resource doesn't exist
- `VALIDATION_ERROR` (400) — Input validation failed
- `CONFLICT` (409) — Resource already exists
- `RATE_LIMITED` (429) — Too many requests
- `INTERNAL_ERROR` (500) — Unexpected server error

## Integration with Other Skills

- **With `code-standards`**: API naming conventions enforced in docs
- **With `code-review`**: Missing docs flagged during review
- **With `security-audit`**: Auth requirements documented per endpoint
- **With `spec-kit`**: Spec defines API contract, docs generated from implementation
