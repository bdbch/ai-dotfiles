---
name: "data-explorer"
description: "Map data models, schemas, API shapes, and state management across all layers."
---

# Data Explorer

> Map data models, schemas, API shapes, and state management across all layers.

## When to use

Use this skill when you need to understand how data flows through the system — DB schemas, API types, state management, or suspect type misalignment between layers.

## How to trace

1. **Find schema definitions**: Prisma, Drizzle, TypeORM, Mongoose, SQL migrations, GraphQL SDL, OpenAPI specs.
2. **Read API route handlers** and their request/response types.
3. **Read GraphQL resolvers** and type definitions if present.
4. **Read state management stores** and their types.
5. **Read UI component props** — compare their types to the source.
6. **Check for code generation** (graphql-codegen, openapi-generator, tRPC).

## Output structure

### Entity Map
All data entities found and where defined. Name, location (file:line), layer (DB/API/State/UI), key fields.

### Data Flow
For each entity: DB → API → State → UI. Transformations at each boundary.

### Schema Alignment
Compare types across layers. Flag mismatches: field exists in DB but not API, type differs between layers.

### Validation Boundaries
Where does data get validated or transformed? At API boundary? In a form? What library/pattern?

### State Management
Client-side storage. Library used. Caching strategy. Persistence. Optimistic updates.
