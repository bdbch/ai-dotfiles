---
name: "Python Development"
description: "Write modern Python — type hints, async/await, OOP, protocols, FastAPI, Pydantic, Django, pytest, packaging, and performance optimization."
---

# Python Development

> Write modern Python — type hints, async/await, OOP, protocols, FastAPI, Pydantic, Django, pytest, packaging, and performance optimization.

## When to use

Use this skill when writing Python code for applications, APIs, scripts, or libraries. Covers modern Python (3.10–3.13+) with type hints, async patterns, popular frameworks, testing, and packaging.

## Core principles

- **Python is dynamically typed but strongly typed** — type hints improve readability, tooling, and catch errors without runtime overhead
- **Explicit is better than implicit** — the Zen of Python guides idiomatic code
- **Python 3.10+ features are the modern baseline** — pattern matching, `|` union syntax, `Self` type, `TypeVar` defaults
- **Async is not always better** — use sync for CPU-bound work, async for I/O-bound work, and know the difference

## Type system

### Basic annotations

```python
def greet(name: str) -> str:
    return f"Hello, {name}"

def process(items: list[int], flag: bool = True) -> dict[str, int]:
    return {str(i): i for i in items if flag}
```

### Union types (3.10+)

```python
# Old (3.9 and earlier)
from typing import Union, Optional
x: Union[int, str] = 1
y: Optional[str] = None

# Modern (3.10+)
x: int | str = 1
y: str | None = None
z: int | float | complex = 1 + 2j
```

### Type aliases

```python
# Simple alias
UserId = int
UserMap = dict[UserId, str]

# TypeAlias (3.10+)
from typing import TypeAlias
JSON: TypeAlias = dict[str, "JSON"] | list["JSON"] | str | int | float | bool | None
```

### Generics

```python
from typing import TypeVar, Generic

T = TypeVar("T")
U = TypeVar("U", bound=User)  # Constrained to User subclasses

class Stack(Generic[T]):
    def __init__(self) -> None:
        self.items: list[T] = []

    def push(self, item: T) -> None: ...
    def pop(self) -> T: ...

# TypeVar with defaults (3.13+)
T = TypeVar("T", default=str)
```

### Protocols (structural subtyping)

```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Drawable(Protocol):
    def draw(self) -> None: ...

class Circle:
    def draw(self) -> None:
        print("Drawing circle")

def render(obj: Drawable) -> None:
    obj.draw()  # Works with any Drawable-compatible type

render(Circle())  # ✅ No explicit inheritance needed
```

### Advanced types

```python
from typing import Literal, TypedDict, Final, Self

# Literal types
def set_mode(mode: Literal["read", "write", "append"]) -> None: ...

# TypedDict
class UserDict(TypedDict):
    id: int
    name: str
    email: str | None

# Final (const)
MAX_RETRIES: Final = 3

# Self type (3.11+)
class Builder:
    def set_name(self, name: str) -> Self:
        self.name = name
        return self
```

## Async programming

### Async/await

```python
import asyncio

async def fetch_data(url: str) -> dict:
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()

async def main() -> None:
    data = await fetch_data("https://api.example.com")
    print(data)

asyncio.run(main())
```

### Task groups (3.11+)

```python
async def main() -> None:
    async with asyncio.TaskGroup() as tg:
        task1 = tg.create_task(fetch_data("url1"))
        task2 = tg.create_task(fetch_data("url2"))
        task3 = tg.create_task(fetch_data("url3"))
    # All tasks complete here
    results = [task1.result(), task2.result(), task3.result()]
```

### Async context managers and iterators

```python
class AsyncResource:
    async def __aenter__(self): ...
    async def __aexit__(self, *args): ...

async def process_items() -> None:
    async for item in async_generator():
        print(item)
```

## FastAPI

```python
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import Annotated

app = FastAPI(title="My API")

# Pydantic models
class ProductCreate(BaseModel):
    name: str
    price: float
    description: str | None = None

class ProductResponse(BaseModel):
    id: int
    name: str
    price: float

# Dependency injection
def get_db():
    db = Database()
    try:
        yield db
    finally:
        db.close()

DbDep = Annotated[Database, Depends(get_db)]

# Endpoints
@app.get("/products/{product_id}", response_model=ProductResponse)
async def get_product(product_id: int, db: DbDep) -> ProductResponse:
    product = db.get_product(product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

@app.post("/products", response_model=ProductResponse, status_code=201)
async def create_product(data: ProductCreate, db: DbDep) -> ProductResponse:
    return db.create_product(data)
```

### FastAPI patterns

```python
# Query parameters
@app.get("/products")
async def list_products(
    search: str | None = None,
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    db: DbDep = None,
): ...

# Form data
from fastapi import Form
@app.post("/submit")
async def submit(name: str = Form(...), file: UploadFile = File(...)): ...

# Background tasks
from fastapi import BackgroundTasks
@app.post("/send-email")
async def send(email: str, tasks: BackgroundTasks):
    tasks.add_task(send_email_task, email)
    return {"message": "Email queued"}
```

## Django

### Models

```python
from django.db import models

class Product(models.Model):
    name = models.CharField(max_length=255)
    slug = models.SlugField(unique=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        indexes = [
            models.Index(fields=["slug"]),
            models.Index(fields=["-created_at"]),
        ]

    def __str__(self) -> str:
        return self.name
```

### Views (DRF)

```python
from rest_framework import viewsets, serializers

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ["id", "name", "slug", "price", "is_active"]

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.filter(is_active=True)
    serializer_class = ProductSerializer

    def get_queryset(self):
        qs = super().get_queryset()
        search = self.request.query_params.get("search")
        if search:
            qs = qs.filter(name__icontains=search)
        return qs
```

### Common ORM patterns

```python
# Queries
Product.objects.filter(is_active=True, price__gte=10)
Product.objects.select_related("category").prefetch_related("tags")
Product.objects.annotate(review_count=Count("reviews"))

# Aggregation
from django.db.models import Avg, Count, Sum
Product.objects.aggregate(avg_price=Avg("price"))

# Bulk operations
Product.objects.bulk_create([Product(name="A"), Product(name="B")])
Product.objects.filter(is_active=False).update(is_active=True)
```

## Testing with pytest

```python
import pytest
from unittest.mock import Mock, patch

# Basic
def test_addition():
    assert 1 + 1 == 2

# Parametrized
@pytest.mark.parametrize("a,b,expected", [
    (1, 2, 3),
    (-1, 1, 0),
    (0, 0, 0),
])
def test_add(a: int, b: int, expected: int) -> None:
    assert add(a, b) == expected

# Fixtures
@pytest.fixture
def db_session():
    db = Database()
    yield db
    db.close()

def test_query(db_session):
    result = db_session.query(...)
    assert result is not None

# Async tests
@pytest.mark.asyncio
async def test_async_fetch():
    data = await fetch_data("test")
    assert data is not None

# Mocking
def test_with_mock():
    mock_service = Mock()
    mock_service.get_data.return_value = {"key": "value"}
    result = process(mock_service)
    assert result["key"] == "value"

# FastAPI test client
from fastapi.testclient import TestClient

def test_read_product(client: TestClient):
    response = client.get("/products/1")
    assert response.status_code == 200
    assert response.json()["id"] == 1
```

## Packaging

```toml
# pyproject.toml
[build-system]
requires = ["setuptools>=64", "wheel"]
build-backend = "setuptools.backends._legacy:_Backend"

[project]
name = "my-package"
version = "0.1.0"
description = "A useful package"
requires-python = ">=3.10"
dependencies = [
    "httpx>=0.25",
    "pydantic>=2.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0",
    "pytest-cov",
    "ruff",
]
test = [
    "pytest>=8.0",
]

[tool.ruff]
line-length = 100
target-version = "py310"

[tool.pytest.ini_options]
testpaths = ["tests"]
```

```bash
pip install -e ".[dev]"   # Editable install with dev deps
uv pip install -e .       # Faster alternative with uv
python -m pytest          # Run tests
ruff check .              # Lint
ruff format .             # Format
mypy .                    # Type check
```

## Performance

```python
# Use __slots__ for many small objects
class Point:
    __slots__ = ("x", "y")

    def __init__(self, x: float, y: float) -> None:
        self.x = x
        self.y = y

# Generator for memory efficiency
def read_large_file(path: str):
    with open(path) as f:
        for line in f:
            yield line.strip()

# Use local variable bindings in hot loops
def process_items(items: list[str]) -> None:
    upper = str.upper  # local reference avoids global lookup
    for item in items:
        result = upper(item)

# Profiling
import cProfile
cProfile.run("my_function()")

# Or use py-spy for production profiling
# py-spy record -o profile.svg --pid 12345
```

## Common pitfalls

- **Mutable default arguments**: `def foo(x=[])` — the list is shared across calls. Use `None` and default inside.
- **Late binding closures**: `[lambda: i for i in range(5)]` — all return 4. Use `lambda i=i: i`.
- **`is` vs `==`**: `is` checks identity, `==` checks equality. Use `is None`, not `== None`.
- **`except Exception` instead of `except:`**: Bare `except:` catches `KeyboardInterrupt` and `SystemExit`. Always catch specific exceptions.
- **Modifying a list while iterating**: Creates a copy: `for item in lst[:]:`.
- **`sys.setrecursionlimit`**: Not a fix for infinite recursion. Fix the algorithm.
- **Import order**: Standard lib → third-party → local. Use `isort` or `ruff`.
- **`os.system` vs `subprocess`**: Always use `subprocess` for running commands.

## Reference

- [Python Documentation](https://docs.python.org/3/)
- [Python Type Hints Cheat Sheet](https://mypy.readthedocs.io/en/stable/cheat_sheet_py3.html)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Django Documentation](https://docs.djangoproject.com/)
- [pytest Documentation](https://docs.pytest.org/)
- [Ruff (linter/formatter)](https://docs.astral.sh/ruff/)
- [uv (package manager)](https://docs.astral.sh/uv/)
