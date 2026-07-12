---
name: "laravel-development"
description: "Build web applications with Laravel — routing, controllers, Eloquent ORM, Blade templating, Artisan CLI, middleware, service container, queues, events, broadcasting, testing, and Laravel ecosystem tools."
---

# Laravel Development

> Build web applications with Laravel — routing, controllers, Eloquent ORM, Blade templating, Artisan CLI, middleware, service container, queues, events, broadcasting, testing, and Laravel ecosystem tools.

## When to use

Use this skill when working with Laravel: building APIs or full-stack applications, defining routes and controllers, modeling data with Eloquent, writing Blade views or Livewire components, managing queues and jobs, implementing authentication, writing tests, or using Laravel ecosystem packages.

## Core architecture

- **MVC-inspired** — Routes map to controllers. Controllers return responses (views, JSON, redirects). Eloquent models represent database tables. Blade templates handle presentation.
- **Service Container** — The central DI container manages class dependencies. Almost everything is resolved through the container, including controllers, middleware, and commands.
- **Facades vs Helpers** — Facades provide static-like access to services resolved from the container. Helper functions (`route()`, `view()`, `response()`) are often more readable.
- **Provider-based bootstrapping** — Service providers register services, bindings, and event listeners in the `boot()` and `register()` methods.
- **Artisan is the CLI** — Scaffold code, run migrations, manage queues, and interact with Tinker (REPL) through Artisan commands.

## Installation & setup

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

### Directory structure

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

## Routing

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

### Route model binding

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

## Controllers

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

### Form requests (validation + authorization)

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

## Eloquent ORM

### Models

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

### Queries

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

### Relationships

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

### Factories & seeders

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

## Blade templating

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

### Blade components

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

### Blade directives

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

## Artisan commands

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

### Custom commands

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

## Middleware

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

### Common built-in middleware

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

## Service Container & providers

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

## Queues & jobs

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

## Events & listeners

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

### Broadcasting (real-time)

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

## Authentication

```bash
php artisan make:auth  # Laravel 11 — use starter kits instead
```

### Starter kits

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

### API authentication with Sanctum

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

## Testing

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

### Pest (alternate testing framework)

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

## Common packages & tools

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

## Pitfalls & gotchas

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

## Reference

- [Laravel Documentation](https://laravel.com/docs)
- [Laravel Bootcamp](https://bootcamp.laravel.com/)
- [Laracasts](https://laracasts.com/)
- [Laravel News](https://laravel-news.com/)
- [Laravel API Reference](https://laravel.com/api/)
- [Laravel GitHub](https://github.com/laravel)
- [Laravel Packages Registry](https://packagist.org/)
