---
description: PHP and Laravel development — PHP 8.x type system, OOP, Eloquent ORM, Blade, Artisan, middleware, queues, events, and testing
mode: subagent
hidden: true
permission:
  edit: allow
  bash: allow
temperature: 0.2
---

# PHP & Laravel Development

## PHP

> Write modern PHP — type system, OOP, PSR standards, Composer, namespaces, traits, generators, attributes, error handling, PDO, streams, and performance optimization.

### When to use

Use this skill when writing PHP code: modern application code, library development, Composer packages, CLI scripts, database access, API integrations, or optimizing legacy PHP. This skill covers the language itself, not any specific framework.

### Core principles

- **PHP is a server-side scripting language** with a shared-nothing architecture (each request starts fresh).
- **PHP 8.x is the modern standard** — type system, named arguments, attributes, enums, match expressions, readonly properties, fibers.
- **PSR standards define ecosystem conventions** — autoloading (PSR-4), coding style (PSR-12), HTTP messages (PSR-7), container (PSR-11), and more.
- **Composer is the dependency manager** — every modern PHP project starts with `composer.json`.
- **PHP runs in a process-per-request model** by default. Long-running applications (via FrankenPHP, Swoole, RoadRunner) change this paradigm.

### Type system

#### Declarations

```php
// Scalar types
int $count = 0;
float $price = 9.99;
string $name = 'hello';
bool $isActive = true;

// Compound types
array $items = [];
object $data = new stdClass();
callable $handler = 'strtolower';
iterable $collection = [];  // array or Traversable

// Nullable (since PHP 7.1)
?string $optional = null;   // string|null

// Union types (since PHP 8.0)
int|float $amount = 0;      // int or float
string|int $id;             // string or int
mixed $anything;            // any type (since PHP 8.0)

// Intersection types (since PHP 8.1)
Countable&ArrayAccess $list;

// Never (since PHP 8.1)
function abort(): never { exit(); }

// Void
function log(): void { /* no return */ }

// False/true (since PHP 8.0/8.2)
function findUser(int $id): User|false { /* ... */ }
function isAvailable(): bool { return true; }

// Null (since PHP 8.2)
function getDefault(): null { return null; }

// DNF types — Disjunctive Normal Form (since PHP 8.2)
function process((Countable&ArrayAccess)|null $items): void {}
```

#### Typed properties

```php
class User
{
    public readonly string $id;    // Read-only (PHP 8.1, set once)
    public string $name;
    protected int $age;
    private ?string $email = null;

    // Constructor promotion (PHP 8.0)
    public function __construct(
        readonly public string $username,
        private string $password,
        public bool $isAdmin = false,
    ) {}
}

$user = new User(username: 'john', password: 'secret');
// Named arguments (PHP 8.0)
```

#### Enums (PHP 8.1)

```php
// Pure enum
enum HttpMethod
{
    case GET;
    case POST;
    case PUT;
    case DELETE;
}

// Backed enum (string or int)
enum UserRole: string
{
    case Admin = 'admin';
    case Editor = 'editor';
    case Viewer = 'viewer';
}

// Enum with methods
enum Status: string
{
    case Pending = 'pending';
    case Active = 'active';
    case Archived = 'archived';

    public function label(): string
    {
        return match ($this) {
            self::Pending => 'Awaiting Review',
            self::Active => 'Currently Active',
            self::Archived => 'Moved to Archive',
        };
    }
}

// Usage
$role = UserRole::Admin;
$role->name;       // 'Admin'
$role->value;      // 'admin'
UserRole::from('admin');     // UserRole::Admin
UserRole::tryFrom('invalid'); // null
```

#### Match expression (PHP 8.0)

```php
$result = match ($status) {
    Status::Pending => 'pending',
    Status::Active => 'active',
    default => 'unknown',
};

// Match with conditions
$output = match (true) {
    $score >= 90 => 'A',
    $score >= 80 => 'B',
    $score >= 70 => 'C',
    default => 'F',
};

// Match is an expression (returns a value)
// Unlike switch, it's strict comparison (===) and doesn't fall through
```

### OOP

#### Classes & inheritance

```php
abstract class Animal
{
    public function __construct(
        protected string $name,
    ) {}

    abstract public function makeSound(): string;

    public function getName(): string
    {
        return $this->name;
    }
}

class Dog extends Animal
{
    public function makeSound(): string
    {
        return 'Woof!';
    }
}

// Final class (cannot be extended)
final class Config
{
    // Final method (cannot be overridden)
    final public function get(string $key): mixed { /* ... */ }
}
```

#### Interfaces

```php
interface CacheInterface
{
    public function get(string $key): mixed;
    public function set(string $key, mixed $value, int $ttl = 3600): void;
    public function delete(string $key): bool;
}

class RedisCache implements CacheInterface
{
    public function get(string $key): mixed { /* ... */ }
    public function set(string $key, mixed $value, int $ttl = 3600): void { /* ... */ }
    public function delete(string $key): bool { /* ... */ }
}
```

#### Traits

```php
trait Timestampable
{
    private \DateTimeImmutable $createdAt;
    private \DateTimeImmutable $updatedAt;

    public function initializeTimestamps(): void
    {
        $this->createdAt = new \DateTimeImmutable();
        $this->updatedAt = new \DateTimeImmutable();
    }

    public function touch(): void
    {
        $this->updatedAt = new \DateTimeImmutable();
    }
}

class Post
{
    use Timestampable;

    public function __construct(
        public string $title,
    ) {
        $this->initializeTimestamps();
    }
}
```

#### Anonymous classes

```php
$logger = new class implements LoggerInterface {
    public function log(string $message): void
    {
        file_put_contents('log.txt', $message . PHP_EOL, FILE_APPEND);
    }
};
```

### Attributes (PHP 8.0+)

```php
// Define
#[Attribute(Attribute::TARGET_CLASS | Attribute::TARGET_METHOD)]
class Route
{
    public function __construct(
        public string $uri,
        public array $methods = ['GET'],
    ) {}
}

// Usage
#[Route('/api/users', methods: ['GET'])]
class UserController
{
    #[Route('/api/users/{id}')]
    public function show(int $id): void
    {
        // ...
    }
}

// Read
$reflection = new ReflectionClass(UserController::class);
$classAttrs = $reflection->getAttributes(Route::class);
$route = $classAttrs[0]->newInstance();
echo $route->uri;  // '/api/users'
```

### Error handling

```php
// Try-catch-finally
try {
    $result = riskyOperation();
} catch (NetworkException | TimeoutException $e) {
    // Multiple exception types
    log::error($e->getMessage());
    throw new ProcessingException('Failed to process', previous: $e);  // Exception chaining
} catch (\Throwable $e) {
    // \Throwable catches everything (errors + exceptions)
    report($e);
} finally {
    cleanup();
}

// Custom exceptions
class ProcessingException extends \RuntimeException {}

// Throwable interface (base for all errors and exceptions)
// \Error → \TypeError, \ValueError, \ParseError, \AssertionError
// \Exception → \RuntimeException, \LogicException, ...

// Assert (PHP 7.0+, throws AssertionError)
assert($value > 0, 'Value must be positive');

// Nullsafe operator (PHP 8.0)
$city = $user?->getAddress()?->city;
// Returns null if any chain member is null, no error

// Null coalescing
$name = $_GET['name'] ?? 'guest';
$config = $config ?? $defaultConfig;  // ??= operator

// Safe call with default
$result = $object?->method() ?? 'default';
```

### PSR standards

| Standard | Purpose |
|----------|---------|
| **PSR-1** | Basic coding standard (PHP tags, side effects, namespaces) |
| **PSR-3** | Logger interface (`Psr\Log\LoggerInterface`) |
| **PSR-4** | Autoloading (`App\` → `src/`, `App\Tests\` → `tests/`) |
| **PSR-7** | HTTP message interfaces (`ServerRequestInterface`, `ResponseInterface`) |
| **PSR-11** | Container interface (`ContainerInterface`) |
| **PSR-12** | Extended coding style (based on PSR-2, more specific) |
| **PSR-14** | Event dispatcher |
| **PSR-17** | HTTP factories |
| **PSR-18** | HTTP client |

### Composer

```json
{
    "name": "vendor/package",
    "description": "A useful package",
    "type": "library",
    "require": {
        "php": ">=8.2",
        "guzzlehttp/guzzle": "^7.0",
        "psr/log": "^3.0"
    },
    "require-dev": {
        "phpunit/phpunit": "^11.0",
        "phpstan/phpstan": "^1.10"
    },
    "autoload": {
        "psr-4": {
            "Vendor\\Package\\": "src/"
        }
    },
    "autoload-dev": {
        "psr-4": {
            "Vendor\\Package\\Tests\\": "tests/"
        }
    },
    "scripts": {
        "test": "phpunit",
        "analyse": "phpstan analyse",
        "cs-fix": "php-cs-fixer fix"
    },
    "minimum-stability": "stable",
    "prefer-stable": true,
    "config": {
        "sort-packages": true
    }
}
```

```bash
composer install          # Install from lock file
composer update           # Update to latest within constraints
composer require vendor/package  # Add dependency
composer require --dev vendor/package  # Dev dependency
composer dump-autoload    # Regenerate autoloader
composer outdated         # Check for outdated deps
composer audit            # Security audit
```

### PDO (database access)

```php
// Connection
$dsn = 'mysql:host=127.0.0.1;port=3306;dbname=app;charset=utf8mb4';
$pdo = new PDO($dsn, 'user', 'password', [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,  // Real prepared statements
]);

// Prepared statements (prevent SQL injection)
$stmt = $pdo->prepare('SELECT * FROM users WHERE email = ?');
$stmt->execute([$email]);
$user = $stmt->fetch();

// Named parameters
$stmt = $pdo->prepare('UPDATE users SET name = :name WHERE id = :id');
$stmt->execute([':name' => $name, ':id' => $id]);

// Fetch modes
$stmt->fetch();              // Single row (assoc by default)
$stmt->fetchAll();           // All rows
$stmt->fetchColumn();        // Single column value
$stmt->fetchObject(User::class);  // As object

// Transactions
$pdo->beginTransaction();
try {
    $pdo->exec('UPDATE accounts SET balance = balance - 100 WHERE id = 1');
    $pdo->exec('UPDATE accounts SET balance = balance + 100 WHERE id = 2');
    $pdo->commit();
} catch (\Throwable $e) {
    $pdo->rollBack();
    throw $e;
}

// Bulk insert
$stmt = $pdo->prepare('INSERT INTO logs (message) VALUES (?)');
$pdo->beginTransaction();
foreach ($messages as $msg) {
    $stmt->execute([$msg]);
}
$pdo->commit();

// Last insert ID
$id = $pdo->lastInsertId();
```

### Streams

```php
// File streams
$handle = fopen('data.csv', 'r');
while (($row = fgetcsv($handle)) !== false) {
    // Process row
}
fclose($handle);

// Memory/ temp streams
$stream = fopen('php://memory', 'r+');
fwrite($stream, 'temporary data');
rewind($stream);
$content = stream_get_contents($stream);
fclose($stream);

// Stream wrappers
file_get_contents('https://example.com');
file_put_contents('compress.zlib://file.gz', $data);

// Custom stream context
$context = stream_context_create([
    'http' => [
        'method' => 'POST',
        'header' => 'Content-Type: application/json',
        'content' => json_encode(['key' => 'value']),
        'timeout' => 5,
    ],
]);
$result = file_get_contents('https://api.example.com', false, $context);
```

### Generators

```php
// Memory-efficient iteration
function processLargeFile(string $path): \Generator
{
    $handle = fopen($path, 'r');
    while (($line = fgets($handle)) !== false) {
        yield trim($line);
    }
    fclose($handle);
}

foreach (processLargeFile('huge-file.txt') as $line) {
    // Process one line at a time — memory stays low
}

// Generator with keys
function map(array $items, callable $fn): \Generator
{
    foreach ($items as $key => $item) {
        yield $key => $fn($item);
    }
}

// Generator delegation
function combine(): \Generator
{
    yield from range(1, 3);    // 1, 2, 3
    yield from ['a', 'b'];     // a, b
}
```

### Fibers (PHP 8.1)

```php
// Cooperative multitasking at the function level
$fiber = new Fiber(function (): void {
    $value = Fiber::suspend('request data');
    // Resume here with $value
});

$result = $fiber->start();
echo $result;  // 'request data'

$fiber->resume('response data');
// Continues in the fiber
```

### Performance optimization

#### OpCache

```ini
; php.ini recommended settings
opcache.enable=1
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=20000
opcache.revalidate_freq=2
opcache.validate_timestamps=0  ; Production (no file checks)
opcache.jit=1255               ; PHP 8.0+ JIT
opcache.jit_buffer_size=256M
```

#### General rules

- **Use OpCache in production** — Always enabled. JIT can give 2-8x speed for CPU-bound code.
- **Avoid `file_get_contents` for repeated files** — Use OpCache (for PHP files) or in-memory cache.
- **String concatenation vs arrays** — For many strings, use `implode()` or `sprintf()`, not `.=` in loops.
- **Use `yield` for large datasets** — Generators keep memory constant regardless of data size.
- **Prefer `isset()` over `array_key_exists()`** — `isset()` is faster (but treats null as not set).
- **Use `[]` over `array_push()`** — `$arr[] = $value` is faster and more readable.
- **Pre-increment in loops** — `++$i` is marginally faster than `$i++` (no temporary copy).
- **Use `match` over `switch`** — `match` is strict (===), returns a value, and avoids fallthrough bugs.
- **Type declarations** — They make code faster (the engine can optimize) and safer.
- **Avoid `@` error suppression** — It's slow and hides bugs. Use proper error handling.

### Code style (PSR-12)

```php
<?php

declare(strict_types=1);

namespace Vendor\Package;

use Vendor\Package\SomeClass;
use function array_map;
use const PHP_VERSION;

class MyClass
{
    public function method(
        string $param1,
        ?int $param2 = null,
        string|int $param3 = '',
    ): string {
        return match ($param1) {
            'a' => 'alpha',
            'b' => 'beta',
            default => 'unknown',
        };
    }
}
```

Rules:
- `<?php` at the top, no closing `?>` at end of file
- `declare(strict_types=1)` after opening tag
- One blank line after namespace, then use statements sorted alphabetically
- 4 spaces for indentation (no tabs)
- Opening brace on same line for classes/methods, on new line for functions
- Space after control keywords: `if ()`, `foreach ()`, `catch ()`
- `else if` vs `elseif`: use `elseif`
- Visibility on all methods and properties (`public`, `protected`, `private`)
- Trailing comma in multi-line arrays and parameter lists (PHP 8.0+)

### Testing with PHPUnit

```php
<?php

declare(strict_types=1);

namespace App\Tests;

use PHPUnit\Framework\TestCase;
use App\Calculator;

class CalculatorTest extends TestCase
{
    private Calculator $calculator;

    protected function setUp(): void
    {
        $this->calculator = new Calculator();
    }

    public function test_add(): void
    {
        $this->assertSame(4, $this->calculator->add(2, 2));
    }

    public function test_divide_by_zero_throws(): void
    {
        $this->expectException(\InvalidArgumentException::class);
        $this->expectExceptionMessage('Division by zero');

        $this->calculator->divide(10, 0);
    }

    /** @dataProvider provideAdditionScenarios */
    public function test_add_with_data_provider(int $a, int $b, int $expected): void
    {
        $this->assertSame($expected, $this->calculator->add($a, $b));
    }

    public static function provideAdditionScenarios(): array
    {
        return [
            'positive' => [1, 2, 3],
            'negative' => [-1, -2, -3],
            'zero'     => [0, 0, 0],
        ];
    }
}
```

### Common SPL classes

```php
// Data structures
\SplStack();        // Stack (LIFO)
\SplQueue();        // Queue (FIFO)
\SplPriorityQueue(); // Priority queue
\SplObjectStorage(); // Object-to-data mapping

// Iterators
\DirectoryIterator('/path');      // List files
\RecursiveDirectoryIterator('/path'); // Recursive file listing
\ArrayIterator(['a', 'b']);       // Array iteration
\LimitIterator($iterator, 0, 10);  // Limit results
\FilterIterator;                   // Custom filtering
\AppendIterator;                   // Combine iterators

// File handling
\SplFileInfo('/path/file.txt');   // File metadata
\SplFileObject('/path/file.txt'); // File as object (iterate lines)

// Exceptions
\InvalidArgumentException;
\LogicException;
\RuntimeException;
\OutOfBoundsException;
\UnexpectedValueException;
```

### Pitfalls & gotchas

- **`==` vs `===`**: `==` does type coercion (`'1' == true` is true). Prefer `===` for strict comparison.
- **Floating point precision**: `0.1 + 0.2 !== 0.3`. Use `bccomp()` or `Money` objects for finances.
- **Reference behavior**: Objects are passed by reference by default. Arrays and scalars are copied on write (COW).
- **`unset()` in foreach**: Modifying an array while iterating can produce unexpected results. Iterate over a copy when modifying.
- **`empty()` vs `isset()`**: `empty()` returns true for `''`, `0`, `null`, `false`, `[]`. `isset()` only checks for `null` and undefined.
- **`include` vs `require`**: `require` throws fatal error on failure. `include` emits a warning. Use `require_once` for shared dependencies.
- **`register_shutdown_function`**: Useful for catching fatal errors, but limited context at that point.
- **Session locking**: PHP sessions lock the session file per request. Concurrent requests for the same session are serialized. Call `session_write_close()` early if you don't need session writes anymore.
- **Maximum execution time**: `max_execution_time` doesn't affect system calls (`sleep()`, DB queries). Use `set_time_limit(0)` for long-running CLI scripts.
- **Integer overflow**: PHP ints are signed 64-bit on 64-bit systems. Operations exceeding `PHP_INT_MAX` become floats.
- **`header()` must be called before output**: Any output (even a space) before `header()` causes "headers already sent". Use output buffering if needed.
- **`exit` vs `die`**: They're identical. Use `exit` for clarity, or throw an exception for testability.
- **Composer autoloader in production**: Run `composer dump-autoload -o` (optimized) to generate classmap for faster loading.
- **Security**: Never use `extract()`, `eval()`, or `preg_replace()` with `/e` modifier (removed in PHP 7). Always validate and escape output.

### Reference

- [PHP Documentation](https://www.php.net/docs.php)
- [PHP RFCs](https://wiki.php.net/rfc)
- [PHP The Right Way](https://phptherightway.com/)
- [Composer](https://getcomposer.org/)
- [PHP-FIG (PSRs)](https://www.php-fig.org/psr/)
- [PHPUnit](https://phpunit.de/)
- [PHPStan](https://phpstan.org/) — Static analysis
- [PHP Security Guide](https://phpsecurity.readthedocs.io/)

## Laravel

> Build web applications with Laravel — routing, controllers, Eloquent ORM, Blade templating, Artisan CLI, middleware, service container, queues, events, broadcasting, testing, and Laravel ecosystem tools.

### When to use

Use this skill when working with Laravel: building APIs or full-stack applications, defining routes and controllers, modeling data with Eloquent, writing Blade views or Livewire components, managing queues and jobs, implementing authentication, writing tests, or using Laravel ecosystem packages.

### Core architecture

- **MVC-inspired** — Routes map to controllers. Controllers return responses (views, JSON, redirects). Eloquent models represent database tables. Blade templates handle presentation.
- **Service Container** — The central DI container manages class dependencies. Almost everything is resolved through the container, including controllers, middleware, and commands.
- **Facades vs Helpers** — Facades provide static-like access to services resolved from the container. Helper functions (`route()`, `view()`, `response()`) are often more readable.
- **Provider-based bootstrapping** — Service providers register services, bindings, and event listeners in the `boot()` and `register()` methods.
- **Artisan is the CLI** — Scaffold code, run migrations, manage queues, and interact with Tinker (REPL) through Artisan commands.

### Installation & setup

```bash
# Via composer
composer create-project laravel/laravel my-app

# Via Laravel installer
composer global require laravel/installer
laravel new my-app

# Via Laravel Sail (Docker)
curl -s "https://laravel.build/my-app" | bash

# Start development
cd my-app && php artisan serve
# Or with Sail:
./vendor/bin/sail up
```

#### Directory structure

```
app/
├── Console/     # Artisan commands
├── Exceptions/  # Error handler
├── Http/
│   ├── Controllers/
│   ├── Middleware/
│   └── Requests/  # Form requests
├── Models/
├── Providers/
└── Services/    # Domain services
bootstrap/
config/
database/
├── migrations/
├── factories/
└── seeders/
public/
resources/
├── views/       # Blade templates
├── css/         # Vite entry
└── js/
routes/
├── web.php      # Web routes (session, CSRF)
├── api.php      # API routes (stateless)
└── console.php  # Artisan commands
tests/
```

### Routing

```php
// routes/web.php — Web routes (with session state, CSRF, cookies)

// Basic route
Route::get('/products', [ProductController::class, 'index']);

// Route with parameters
Route::get('/products/{product}', [ProductController::class, 'show']);

// Named route
Route::get('/products/{product}/edit', [ProductController::class, 'edit'])
    ->name('products.edit');

// Route with constraints
Route::get('/products/{product:slug}', [ProductController::class, 'show']);
// Route::get('/users/{user}', [UserController::class, 'show'])
//     ->where('user', '[0-9]+');

// Route groups
Route::middleware(['auth', 'verified'])->prefix('admin')->group(function () {
    Route::get('/dashboard', [AdminController::class, 'dashboard']);
    Route::resource('products', ProductController::class);
});

// Resource routes
Route::resource('products', ProductController::class);
// Generates: index, create, store, show, edit, update, destroy
// Only some: Route::apiResource('products', ProductController::class);

// API routes (routes/api.php — no session state)
Route::apiResource('products', ProductApiController::class);
```

#### Route model binding

```php
// Implicit binding — type-hint the model
Route::get('/products/{product}', function (Product $product) {
    return $product;
    // Automatically resolved by ID, or custom column via route key
});

// Custom key
Route::get('/products/{product:slug}', function (Product $product) {
    return $product; // Resolved by slug column
});

// Explicit binding in RouteServiceProvider
Route::bind('product', function (string $value) {
    return Product::where('slug', $value)->firstOrFail();
});
```

### Controllers

```php
<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Illuminate\Http\RedirectResponse;

class ProductController extends Controller
{
    public function index(): View
    {
        $products = Product::latest()->paginate(12);
        return view('products.index', compact('products'));
    }

    public function create(): View
    {
        return view('products.create');
    }

    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'description' => 'nullable|string',
        ]);

        $product = Product::create($validated);

        return redirect()->route('products.index')
            ->with('success', 'Product created.');
    }

    public function show(Product $product): View
    {
        return view('products.show', compact('product'));
    }

    public function update(Request $request, Product $product): RedirectResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
        ]);

        $product->update($validated);

        return redirect()->route('products.index')
            ->with('success', 'Product updated.');
    }

    public function destroy(Product $product): RedirectResponse
    {
        $product->delete();

        return redirect()->route('products.index')
            ->with('success', 'Product deleted.');
    }
}
```

#### Form requests (validation + authorization)

```php
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreProductRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('create', Product::class);
    }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'price' => ['required', 'numeric', 'min:0'],
            'category_id' => ['required', 'exists:categories,id'],
            'description' => ['nullable', 'string', 'max:5000'],
        ];
    }

    public function messages(): array
    {
        return [
            'title.required' => 'A product title is required.',
        ];
    }
}

// In controller:
public function store(StoreProductRequest $request): RedirectResponse
{
    Product::create($request->validated());
    // ...
}
```

### Eloquent ORM

#### Models

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use SoftDeletes;  // Adds deleted_at column

    // Table, primary key, timestamps
    protected $table = 'products';
    protected $primaryKey = 'id';
    public $timestamps = true;

    // Mass assignment
    protected $fillable = ['title', 'slug', 'price', 'description', 'category_id'];
    // protected $guarded = ['id', 'created_at']; // Opposite approach
    protected $hidden = ['secret_note'];

    // Casts
    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'is_active' => 'boolean',
            'metadata' => 'array',
            'published_at' => 'datetime',
        ];
    }

    // Relationships
    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function tags(): BelongsToMany
    {
        return $this->belongsToMany(Tag::class)
            ->withTimestamps();
    }

    // Accessors & mutators
    public function getFormattedPriceAttribute(): string
    {
        return '$' . number_format($this->price, 2);
    }

    public function setSlugAttribute(string $value): void
    {
        $this->attributes['slug'] = str($value)->slug();
    }

    // Scopes
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopePriceRange($query, $min, $max)
    {
        return $query->whereBetween('price', [$min, $max]);
    }
}
```

#### Queries

```php
// Basic
Product::all();
Product::find($id);
Product::findOrFail($id);
Product::where('is_active', true)->get();
Product::firstWhere('slug', 'example');

// Aggregates
Product::count();
Product::where('category_id', 1)->sum('price');
Product::avg('price');

// Eager loading
Product::with('category', 'tags')->get();
Product::withCount('reviews')->get();
Product::load('category');  // On existing collection

// Lazy eager load
$products = Product::all();
$products->load('category');

// Where has
Product::whereHas('reviews', fn($q) => $q->where('rating', '>=', 4))->get();
Product::doesntHave('reviews')->get();

// Pagination
Product::paginate(15);
Product::simplePaginate(15);  // No total count (faster)
Product::cursorPaginate(15);  // For large datasets

// Chunking (for memory management)
Product::chunk(100, function ($products) {
    foreach ($products as $product) {
        // Process
    }
});

// Lazy collection (cursor-based)
foreach (Product::lazy(200) as $product) {
    // Memory-efficient iteration
}
```

#### Relationships

```php
// One to One
public function profile(): HasOne { return $this->hasOne(Profile::class); }

// One to Many
public function posts(): HasMany { return $this->hasMany(Post::class); }

// Many to Many
public function roles(): BelongsToMany {
    return $this->belongsToMany(Role::class)
        ->withPivot('expires_at')
        ->withTimestamps();
}

// Has Many Through
public function postComments(): HasManyThrough {
    return $this->hasManyThrough(Comment::class, Post::class);
}

// Polymorphic
public function images(): MorphMany {
    return $this->morphMany(Image::class, 'imageable');
}

// Many to Many Polymorphic
public function tags(): MorphToMany {
    return $this->morphToMany(Tag::class, 'taggable');
}
```

#### Factories & seeders

```php
// database/factories/ProductFactory.php
class ProductFactory extends Factory
{
    protected $model = Product::class;

    public function definition(): array
    {
        return [
            'title' => fake()->words(3, true),
            'price' => fake()->randomFloat(2, 1, 999),
            'is_active' => fake()->boolean(80),
            'category_id' => Category::factory(),
        ];
    }

    public function inactive(): static
    {
        return $this->state(fn(array $attrs) => [
            'is_active' => false,
        ]);
    }
}

// database/seeders/DatabaseSeeder.php
class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        Product::factory(50)
            ->has(Review::factory(rand(0, 10)))
            ->create();
    }
}
```

### Blade templating

```blade
{{-- layouts/app.blade.php --}}
<!DOCTYPE html>
<html>
<head>
    <title>@yield('title', 'Default')</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body>
    <nav>@include('partials.nav')</nav>

    <main class="container">
        @yield('content')
    </main>

    @stack('scripts')
</body>
</html>

{{-- products/index.blade.php --}}
@extends('layouts.app')

@section('title', 'Products')

@section('content')
    <div class="grid">
        @forelse($products as $product)
            <x-product-card :product="$product" />
        @empty
            <p>No products found.</p>
        @endforelse
    </div>

    {{ $products->links() }}

    @push('scripts')
        <script src="/js/products.js"></script>
    @endpush
@endsection
```

#### Blade components

```blade
{{-- components/product-card.blade.php --}}
@props(['product' => null])

<div class="card">
    <h3>{{ $product->title }}</h3>
    <p class="price">{{ $product->formatted_price }}</p>
    @if($product->is_active)
        <span class="badge badge-success">Active</span>
    @else
        <span class="badge badge-muted">Inactive</span>
    @endif
    {{ $slot }}
</div>

{{-- Usage --}}
<x-product-card :product="$product">
    <a href="{{ route('products.show', $product) }}">View details</a>
</x-product-card>
```

#### Blade directives

```blade
@if, @elseif, @else, @endif
@unless (condition)
@isset, @empty
@for, @foreach, @forelse, @while
@each('partials.item', $items, 'item')
@break, @continue

@auth / @guest          {{-- Auth checks --}}
@can('update', $post)   {{-- Authorization --}}

@csrf
@method('DELETE')

@lang('messages.welcome')  {{-- Localization --}}

@php
    // Inline PHP (avoid when possible)
@endphp

{{-- Directives for form/model binding --}}
@error('email')
    <span>{{ $message }}</span>
@enderror
```

### Artisan commands

```bash
# Make commands
php artisan make:controller ProductController
php artisan make:model Product -mfsc  # Model + migration + factory + seeder + controller
php artisan make:request StoreProductRequest
php artisan make:command SendInvoices
php artisan make:mail OrderConfirmation
php artisan make:notification InvoicePaid
php artisan make:job ProcessPodcast
php artisan make:event OrderShipped
php artisan make:listener SendShipmentNotification
php artisan make:middleware EnsureTokenIsValid

# Database
php artisan migrate
php artisan migrate:fresh --seed
php artisan db:seed
php artisan make:migration create_products_table

# Cache & config
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize

# Tinker (REPL)
php artisan tinker

# Queue
php artisan queue:work
php artisan queue:table

# Storage
php artisan storage:link
```

#### Custom commands

```php
<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class SendInvoices extends Command
{
    protected $signature = 'invoices:send
                           {--queue : Queue the job}
                           {user? : Specific user ID}';

    protected $description = 'Send pending invoices';

    public function handle(): int
    {
        $users = $this->argument('user')
            ? User::where('id', $this->argument('user'))->get()
            : User::all();

        $this->withProgressBar($users, function (User $user) {
            // Send invoice
        });

        $this->info('Invoices sent successfully!');
        $this->newLine();

        return Command::SUCCESS; // or Command::FAILURE
    }
}
```

### Middleware

```php
// Custom middleware
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class EnsureTokenIsValid
{
    public function handle(Request $request, Closure $next, string $role = null): mixed
    {
        if ($request->input('token') !== config('app.api_token')) {
            return redirect()->route('login');
        }

        return $next($request);
    }
}

// In Kernel (or registered in routes)
Route::middleware(['auth', 'verified'])->group(function () {
    // ...
});

// Route-level
Route::put('/admin/{post}', ...)->middleware('can:update,post');
```

#### Common built-in middleware

| Middleware | Purpose |
|-----------|---------|
| `auth` | Redirect unauthenticated users |
| `verified` | Only verified email users |
| `throttle:60,1` | Rate limit (60 requests per minute) |
| `can:update,post` | Authorization |
| `guest` | Only unauthenticated users |
| `password.confirm` | Require password re-entry |
| `signed` | Verify signed URLs |
| `cache.headers` | Set cache headers |

### Service Container & providers

```php
// Binding in AppServiceProvider
public function register(): void
{
    $this->app->bind(PaymentGateway::class, function ($app) {
        return new StripeGateway(config('services.stripe.secret'));
    });

    $this->app->singleton(Logger::class, function ($app) {
        return new Logger(storage_path('logs/app.log'));
    });

    // Interface to implementation
    $this->app->bind(OrderRepositoryInterface::class, OrderRepository::class);
}

// Resolving
$gateway = app(PaymentGateway::class);
$gateway = resolve(PaymentGateway::class);
$gateway = app()->make(PaymentGateway::class);

// Automatic injection in controllers, commands, middleware, events
class ProductController extends Controller {
    public function __construct(
        protected PaymentGateway $gateway,
    ) {}
}
```

### Queues & jobs

```php
<?php

namespace App\Jobs;

use App\Models\Product;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Log;

class ProcessProduct implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public Product $product,
    ) {}

    public function handle(): void
    {
        // Process the product
        Log::info('Processing product: ' . $this->product->title);
    }

    // Optional: failed callback
    public function failed(\Throwable $e): void
    {
        Log::error('Failed to process product: ' . $e->getMessage());
    }
}

// Dispatching
ProcessProduct::dispatch($product);
ProcessProduct::dispatch($product)->delay(now()->addMinutes(10));
ProcessProduct::dispatch($product)->onQueue('processing');

// Chain
Bus::chain([
    new ProcessProduct($product),
    new OptimizeImages($product),
    new NotifyCustomer($product),
])->dispatch();
```

### Events & listeners

```php
// Event
class OrderShipped
{
    public function __construct(
        public Order $order,
    ) {}
}

// Listener
class SendShipmentNotification
{
    public function handle(OrderShipped $event): void
    {
        $event->order->user->notify(new ShipmentNotification($event->order));
    }
}

// Register in EventServiceProvider
protected $listen = [
    OrderShipped::class => [
        SendShipmentNotification::class,
        UpdateInventory::class,
    ],
];

// Dispatch
event(new OrderShipped($order));
OrderShipped::dispatch($order);  // With trait

// Auto-discovery — listeners in app/Listeners with handle() method
```

#### Broadcasting (real-time)

```php
// Channel definition in routes/channels.php
Broadcast::channel('orders.{orderId}', function (User $user, int $orderId) {
    return $user->id === Order::findOrFail($orderId)->user_id;
});

// Broadcasting event
class OrderStatusUpdated implements ShouldBroadcast
{
    public function broadcastOn(): array
    {
        return [
            new PrivateChannel('orders.' . $this->order->id),
        ];
    }
}

// Client-side (Laravel Echo)
Echo.private('orders.' + orderId)
    .listen('OrderStatusUpdated', (e) => {
        console.log('Status:', e.order.status);
    });
```

### Authentication

```bash
php artisan make:auth  # Laravel 11 — use starter kits instead
```

#### Starter kits

```bash
# Laravel Breeze (simple, minimal)
composer require laravel/breeze --dev
php artisan breeze:install
php artisan breeze:install --api  # API-only
php artisan breeze:install --blade  # Blade with Alpine
php artisan breeze:install --react  # React + Inertia
php artisan breeze:install --vue    # Vue + Inertia

# Laravel Jetstream (more features: teams, 2FA, API tokens)
composer require laravel/jetstream
php artisan jetstream:install livewire  # or jetstream:install inertia
```

#### API authentication with Sanctum

```php
// config/sanctum.php
// api.php routes are token-authenticated by default

// Issue token
$token = $user->createToken('api-token', ['read:products', 'write:products'])->plainTextToken;

// Middleware
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Token abilities
if ($request->user()->tokenCan('read:products')) {
    // ...
}
```

### Testing

```php
<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;

class ProductTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_list_products(): void
    {
        Product::factory(3)->create();

        $response = $this->getJson('/api/products');

        $response->assertOk();
        $response->assertJsonCount(3, 'data');
    }

    public function test_can_create_product(): void
    {
        $data = Product::factory()->make()->toArray();

        $response = $this->postJson('/api/products', $data);

        $response->assertCreated();
        $this->assertDatabaseHas('products', ['title' => $data['title']]);
    }

    public function test_validation_fails_for_missing_fields(): void
    {
        $response = $this->postJson('/api/products', []);

        $response->assertUnprocessable();
        $response->assertJsonValidationErrors(['title', 'price']);
    }

    // HTTP tests
    public function test_authenticated_user_can_access_dashboard(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->get('/dashboard');
        $response->assertOk();
    }

    // Mocking
    public function test_queues_job_on_product_creation(): void
    {
        Bus::fake();

        $this->postJson('/api/products', Product::factory()->raw());

        Bus::assertDispatched(ProcessProduct::class);
    }
}
```

#### Pest (alternate testing framework)

```php
uses(RefreshDatabase::class);

it('can list products', function () {
    Product::factory(3)->create();

    $response = $this->getJson('/api/products');

    $response->assertOk()->assertJsonCount(3, 'data');
});

it('validates required fields', function () {
    $response = $this->postJson('/api/products', []);

    $response->assertUnprocessable()
        ->assertJsonValidationErrors(['title', 'price']);
});
```

### Common packages & tools

| Package | Purpose |
|---------|---------|
| **Laravel Livewire** | Full-stack dynamic UI with Blade |
| **Laravel Nova** | Admin panel |
| **Laravel Horizon** | Queue monitoring |
| **Laravel Telescope** | Debugging & logging |
| **Laravel Pulse** | Application monitoring |
| **Laravel Scout** | Full-text search (Algolia, Meilisearch) |
| **Laravel Passport** | OAuth2 server |
| **Laravel Sanctum** | API tokens & SPA auth |
| **Laravel Cashier** | Subscription billing (Stripe, Paddle) |
| **Laravel Socialite** | Social login |
| **Laravel Dusk** | Browser testing |
| **Laravel Pennant** | Feature flags |
| **Laravel Reverb** | WebSocket server |
| **Laravel Octane** | High-performance server (RoadRunner, Swoole) |
| **Laravel Sail** | Docker development environment |
| **Laravel Pint** | Code style fixer |
| **Laravel Herd** | Local PHP dev environment |
| **Laravel Vapor** | Serverless deployment |

### Pitfalls & gotchas

- **N+1 queries**: Always eager-load relationships with `->with()`. Use `Model::preventLazyLoading()` in local dev.
- **Mass assignment**: Use `$fillable` or `$guarded` on all models. Never pass unvalidated request data to `create()`.
- **Env in production**: `config:cache` freezes `.env` values. Changes require re-cache. Never use `env()` outside config files.
- **Queue worker restarts**: After code changes, restart queue workers (`php artisan queue:restart`). Deploy scripts should handle this.
- **Session in API routes**: `api.php` routes don't have session state. Use tokens (Sanctum) or JWT for API auth.
- **`dd()` in production**: Never commit `dd()`, `dump()`, or `ray()` calls.
- **File permissions**: `storage/` and `bootstrap/cache/` must be writable by the web server.
- **Composer version constraints**: Use `^` for forward-compatible versions. Run `composer update` with care in production.
- **Horizon/Octane**: These change the request lifecycle. Background jobs and singleton behavior differ. Test thoroughly.
- **Blade vs Livewire**: Blade is static. Livewire adds dynamic reactivity without writing JS. Choose based on your interactive needs.
- **`php artisan serve` is for development only**: Use Nginx, Caddy, or Laravel Octane in production.
- **Pint for consistency**: Use `./vendor/bin/pint` (Laravel's code style fixer) in CI to enforce PSR-12.

### Reference

- [Laravel Documentation](https://laravel.com/docs)
- [Laravel Bootcamp](https://bootcamp.laravel.com/)
- [Laracasts](https://laracasts.com/)
- [Laravel News](https://laravel-news.com/)
- [Laravel API Reference](https://laravel.com/api/)
- [Laravel GitHub](https://github.com/laravel)
- [Laravel Packages Registry](https://packagist.org/)
