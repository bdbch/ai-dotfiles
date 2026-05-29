---
name: "Database Design"
description: "Design effective database schemas — normalization, indexing strategies, relationships, migrations, query optimization, and data modeling patterns for SQL and NoSQL."
---

# Database Design

> Design effective database schemas — normalization, indexing strategies, relationships, migrations, query optimization, and data modeling patterns for SQL and NoSQL.

## When to use

Use this skill when designing database schemas, planning migrations, optimizing queries, or choosing between SQL and NoSQL for a use case.

## Core principles

- **Schema design is about access patterns, not just entity relationships** — design for how you'll query the data
- **Normalize for consistency, denormalize for performance** — start normalized, denormalize intentionally
- **Indexes are not free** — each index adds write overhead and storage cost
- **The database is a shared resource** — schema design affects every query, migration, and team member

## Normalization

### Normal forms

| Form | Rule | Example violation |
|------|------|-------------------|
| 1NF | Each cell contains a single atomic value | A column with comma-separated tags |
| 2NF | Every non-key column depends on the whole primary key | `order_id, product_id, customer_name` — customer depends only on order, not product |
| 3NF | Every non-key column depends only on the primary key | `product_id, category_name, category_description` — description depends on category, not product |

**When to denormalize:**
- Read-heavy workloads where joins are expensive
- Pre-computed aggregates (counts, sums) that change infrequently
- Cache-like data that can tolerate staleness
- Reporting/analytics tables designed for query speed

### Common relationship patterns

```sql
-- One-to-many (most common)
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id),
    product_id BIGINT NOT NULL REFERENCES products(id),
    quantity INT NOT NULL
);
CREATE INDEX idx_order_items_order ON order_items(order_id);

-- Many-to-many
CREATE TABLE products_tags (
    product_id BIGINT NOT NULL REFERENCES products(id),
    tag_id BIGINT NOT NULL REFERENCES tags(id),
    PRIMARY KEY (product_id, tag_id)
);

-- Polymorphic (use with caution)
CREATE TABLE comments (
    id BIGSERIAL PRIMARY KEY,
    author_id BIGINT NOT NULL,
    commentable_type VARCHAR(50) NOT NULL,  -- 'post' or 'video'
    commentable_id BIGINT NOT NULL,
    body TEXT NOT NULL
);
CREATE INDEX idx_comments_polymorphic ON comments(commentable_type, commentable_id);
```

## Indexing

### Index types

| Index type | Best for | PostgreSQL syntax |
|------------|----------|-------------------|
| B-tree (default) | Equality and range queries, sorting | `CREATE INDEX ON users(email)` |
| Hash | Equality only | `CREATE INDEX ON users USING hash(email)` |
| GiST | Full-text search, geometric data | `CREATE INDEX ON documents USING gist(content)` |
| GIN | Array/JSON containment checks | `CREATE INDEX ON products USING gin(tags)` |
| BRIN | Very large, naturally ordered tables | `CREATE INDEX ON logs USING brin(created_at)` |
| Composite | Multi-column queries | `CREATE INDEX ON orders(user_id, created_at)` |

### Index design rules

```sql
-- Most selective column first (for composite indexes)
CREATE INDEX ON orders(user_id, status, created_at DESC);
-- Query: WHERE user_id = 123 AND status = 'active' ORDER BY created_at DESC

-- Covering index (includes data, avoids table lookup)
CREATE INDEX ON products(category_id) INCLUDE (name, price);

-- Partial index (only index relevant rows)
CREATE INDEX ON orders(created_at) WHERE status = 'pending';

-- Unique index (enforces uniqueness)
CREATE UNIQUE INDEX ON users(email) WHERE deleted_at IS NULL;
```

### When NOT to index

- Small tables (< 1000 rows)
- Columns with very few distinct values (e.g., boolean with 50/50 split)
- Columns that are rarely queried
- Tables with very high write volume (index maintenance cost)
- Columns where the query pattern is unknown

## Query optimization

### Use EXPLAIN ANALYZE

```sql
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT u.name, COUNT(o.id)
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.created_at > '2024-01-01'
GROUP BY u.id;
```

Look for:
- **Seq Scan** on large tables — needs an index
- **Nested Loop** vs **Hash Join** — hash join is usually better for large datasets
- **Sort** without index — an index on the sort column helps
- **Rows Removed by Filter** — high numbers suggest a better index is needed

### Common optimization patterns

```sql
-- Instead of:
SELECT * FROM orders WHERE EXTRACT(YEAR FROM created_at) = 2024;

-- Use range query (sargable — uses index):
SELECT * FROM orders
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';

-- Instead of:
SELECT * FROM products WHERE CONCAT(name, ' ', description) LIKE '%search%';

-- Use full-text search:
CREATE INDEX ON products USING gin(to_tsvector('english', name || ' ' || description));
SELECT * FROM products
WHERE to_tsvector('english', name || ' ' || description) @@ to_tsquery('english', 'search');
```

### N+1 query detection

```
Problem:
  for each user in users:
    orders = db.query("SELECT * FROM orders WHERE user_id = ?", user.id)
  → N+1 queries

Fix:
  users = db.query("SELECT * FROM users")
  orders = db.query("SELECT * FROM orders WHERE user_id = ANY(?)", [u.id for u in users])
```

## Migrations

### Principles for safe migrations

```sql
-- 1. Additive changes first (add columns/tables before using them)
ALTER TABLE users ADD COLUMN display_name VARCHAR(255);

-- 2. Backfill data in a separate step
UPDATE users SET display_name = name WHERE display_name IS NULL;

-- 3. Start using new column in application code

-- 4. Remove old column (much later, after verifying no code uses it)
ALTER TABLE users DROP COLUMN name;
```

### Zero-downtime migration patterns

| Change type | Safe approach |
|-------------|---------------|
| Add column | Safe if nullable or has default |
| Add NOT NULL column | Add nullable → backfill → add NOT NULL constraint |
| Rename column | Add new column → dual-write → backfill → switch reads → drop old |
| Rename table | Create view with old name → migrate code → drop view |
| Add index | `CREATE INDEX CONCURRENTLY` (PostgreSQL) — doesn't lock table |
| Drop index | `DROP INDEX CONCURRENTLY` (PostgreSQL) |
| Add foreign key | `ADD CONSTRAINT ... NOT VALID` → `VALIDATE CONSTRAINT` |

## Data types

```sql
-- Prefer these:
TIMESTAMPTZ      -- Always store with timezone
UUID             -- For distributed IDs, or
BIGSERIAL        -- For auto-increment integers
TEXT             -- Over VARCHAR(n) unless you need length checks
NUMERIC(10,2)    -- For money (avoid FLOAT)
JSONB            -- For unstructured data (over JSON)
BOOLEAN          -- For flags
ENUM             -- For fixed sets of values (or reference table)
```

## NoSQL considerations

| Use case | Document store (MongoDB) | Key-value (Redis) | Search (Elastic) |
|----------|------------------------|-------------------|-------------------|
| Flexible schema | ✅ Yes | ❌ | ❌ |
| Complex queries | ⚠️ Limited | ❌ | ✅ Full-text |
| Joins | ❌ Embed or app-level | ❌ | ❌ Denormalize |
| Transactions | ⚠️ Limited (≥4.0) | ❌ | ❌ |
| High-volume writes | ✅ | ✅ | ⚠️ |
| Caching | ❌ | ✅ Primary use | ❌ |

## Naming conventions

```sql
-- Tables: plural snake_case
users, order_items, product_categories

-- Columns: singular snake_case
id, user_id, created_at

-- Primary key: always `id BIGSERIAL PRIMARY KEY`
-- Foreign key: `referenced_table_singular_id`
-- Junction tables: `table1_table2` in alphabetical order
-- Indexes: `idx_table_column` or `idx_table_col1_col2`
-- Unique constraints: `uq_table_column`
```

## Pitfalls & gotchas

- **UUID as primary key**: Can fragment B-tree indexes. Use sequential UUIDs (UUID v7) or `uuid_generate_v7()` in PostgreSQL.
- **SELECT ***: Returns all columns, can't be index-only, breaks on schema changes. Name the columns you need.
- **Implicit type coercion**: `WHERE user_id = '123'` may not use an index if the column is integer. Match types.
- **OR in WHERE clauses**: Often can't use indexes effectively. `UNION ALL` can be faster.
- **Over-indexing**: More indexes ≠ faster queries. Monitor index usage with `pg_stat_user_indexes`.
- **Large JSONB blobs**: You can't index into JSONB like regular columns. Extract frequently-queried fields to real columns.
- **Missing foreign keys**: They prevent orphaned data and give the query planner better information. Always use them.
- **`COUNT(*)` on large tables**: It's slow on PostgreSQL (MVCC). Use approximate counts or a separate counter table.

## Reference

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Use the Index, Luke](https://use-the-index-luke.com/) — comprehensive indexing guide
- [Database Design for Mere Mortals](https://www.informit.com/store/database-design-for-mere-mortals-9780136788041)
- [pgMustard](https://www.pgmustard.com/) — EXPLAIN analyzer
