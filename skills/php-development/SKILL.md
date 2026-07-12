---
name: "php-development"
description: "Write modern PHP — type system, OOP, PSR standards, Composer, namespaces, traits, generators, attributes, error handling, PDO, streams, and performance optimization."
---

# PHP Development

> Write modern PHP — type system, OOP, PSR standards, Composer, namespaces, traits, generators, attributes, error handling, PDO, streams, and performance optimization.

## When to use

Use this skill when writing PHP code: modern application code, library development, Composer packages, CLI scripts, database access, API integrations, or optimizing legacy PHP. This skill covers the language itself, not any specific framework.

## Core principles

- **PHP is a server-side scripting language** with a shared-nothing architecture (each request starts fresh).
- **PHP 8.x is the modern standard** — type system, named arguments, attributes, enums, match expressions, readonly properties, fibers.
- **PSR standards define ecosystem conventions** — autoloading (PSR-4), coding style (PSR-12), HTTP messages (PSR-7), container (PSR-11), and more.
- **Composer is the dependency manager** — every modern PHP project starts with `composer.json`.
- **PHP runs in a process-per-request model** by default. Long-running applications (via FrankenPHP, Swoole, RoadRunner) change this paradigm.

## Type system

### Declarations

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

### Typed properties

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

### Enums (PHP 8.1)

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

### Match expression (PHP 8.0)

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

## OOP

### Classes & inheritance

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

### Interfaces

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

### Traits

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

### Anonymous classes

```php
$logger = new class implements LoggerInterface {
    public function log(string $message): void
    {
        file_put_contents('log.txt', $message . PHP_EOL, FILE_APPEND);
    }
};
```

## Attributes (PHP 8.0+)

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

## Error handling

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

## PSR standards

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

## Composer

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

## PDO (database access)

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

## Streams

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

## Generators

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

## Fibers (PHP 8.1)

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

## Performance optimization

### OpCache

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

### General rules

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

## Code style (PSR-12)

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

## Testing with PHPUnit

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

## Common SPL classes

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

## Pitfalls & gotchas

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

## Reference

- [PHP Documentation](https://www.php.net/docs.php)
- [PHP RFCs](https://wiki.php.net/rfc)
- [PHP The Right Way](https://phptherightway.com/)
- [Composer](https://getcomposer.org/)
- [PHP-FIG (PSRs)](https://www.php-fig.org/psr/)
- [PHPUnit](https://phpunit.de/)
- [PHPStan](https://phpstan.org/) — Static analysis
- [PHP Security Guide](https://phpsecurity.readthedocs.io/)
