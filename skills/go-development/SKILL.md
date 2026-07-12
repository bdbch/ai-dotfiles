---
name: "go-development"
description: "Write idiomatic Go — packages, interfaces, goroutines, channels, error handling, testing, modules, HTTP services, and common patterns."
---

# Go Development

> Write idiomatic Go — packages, interfaces, goroutines, channels, error handling, testing, modules, HTTP services, and common patterns.

## When to use

Use this skill when writing Go code for CLI tools, services, APIs, or infrastructure tooling. Covers idiomatic Go patterns, concurrency, error handling, testing, and project structure.

## Core principles

- **Simplicity over cleverness** — Go favors straightforward code over abstractions
- **Explicit error handling** — errors are values, not exceptions. Check and handle them immediately
- **Composition over inheritance** — use interfaces and embedding, not class hierarchies
- **Concurrency is a built-in tool** — goroutines and channels make concurrent programming accessible, but not free

## Project structure

```
myproject/
├── cmd/
│   └── server/
│       └── main.go         # Entry point (thin — just parse flags, start server)
├── internal/
│   ├── handler/             # HTTP handlers
│   ├── service/             # Business logic
│   ├── repository/          # Data access
│   └── model/               # Domain types
├── pkg/                     # Shared library code (importable by external projects)
├── go.mod
├── go.sum
└── Makefile
```

## Types and interfaces

### Structs

```go
type User struct {
    ID        int64     `json:"id"`
    Name      string    `json:"name"`
    Email     string    `json:"email,omitempty"`
    CreatedAt time.Time `json:"created_at"`
    deleted   bool      // Unexported — not serialized
}

// Constructor function (idiomatic Go doesn't use class constructors)
func NewUser(name, email string) *User {
    return &User{
        Name:      name,
        Email:     email,
        CreatedAt: time.Now(),
    }
}
```

### Methods

```go
// Value receiver — doesn't modify the struct
func (u User) FullName() string {
    return u.Name
}

// Pointer receiver — can modify
func (u *User) Activate() {
    u.deleted = false
}

// Interface compliance (compile-time check)
var _ json.Marshaler = (*User)(nil)
```

### Interfaces

```go
// Define interfaces where they're USED, not where they're implemented
type Storage interface {
    Get(ctx context.Context, id int64) (*User, error)
    Save(ctx context.Context, user *User) error
    List(ctx context.Context) ([]*User, error)
}

// Accept interfaces, return structs
func NewHandler(storage Storage) *Handler {
    return &Handler{storage: storage}
}
```

### Generics (1.18+)

```go
// Generic function
func Map[T, U any](items []T, fn func(T) U) []U {
    result := make([]U, len(items))
    for i, item := range items {
        result[i] = fn(item)
    }
    return result
}

// Generic type
type Stack[T any] struct {
    items []T
}

func (s *Stack[T]) Push(item T) {
    s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() (T, bool) {
    if len(s.items) == 0 {
        var zero T
        return zero, false
    }
    item := s.items[len(s.items)-1]
    s.items = s.items[:len(s.items)-1]
    return item, true
}
```

## Error handling

```go
import (
    "errors"
    "fmt"
)

// Sentinel errors
var ErrNotFound = errors.New("user not found")

// Custom error type
type ValidationError struct {
    Field string
    Value any
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("invalid %s: %v", e.Field, e.Value)
}

// Error wrapping
func GetUser(ctx context.Context, id int64) (*User, error) {
    user, err := storage.Get(ctx, id)
    if err != nil {
        return nil, fmt.Errorf("get user %d: %w", id, err)
    }
    return user, nil
}

// Error checking
user, err := GetUser(ctx, 123)
if err != nil {
    if errors.Is(err, ErrNotFound) {
        // Handle not found
    }
    var valErr *ValidationError
    if errors.As(err, &valErr) {
        fmt.Printf("Field %s is invalid\n", valErr.Field)
    }
    return
}
```

## Concurrency

### Goroutines

```go
go func() {
    result := doWork()
    // Runs concurrently
}()

// Wait for completion
var wg sync.WaitGroup
for _, item := range items {
    wg.Add(1)
    go func(i Item) {
        defer wg.Done()
        process(i)
    }(item)
}
wg.Wait()
```

### Channels

```go
// Unbuffered channel (synchronous send/receive)
ch := make(chan int)

// Buffered channel
ch := make(chan string, 10)

// Send
ch <- value

// Receive
value := <-ch
value, ok := <-ch  // ok = false if channel is closed

// Range over channel
for msg := range ch {
    fmt.Println(msg)
}

// Select (multiplex channels)
select {
case msg := <-msgCh:
    fmt.Println("received:", msg)
case <-timeout:
    fmt.Println("timeout")
case <-ctx.Done():
    fmt.Println("cancelled")
}
```

### Worker pool pattern

```go
func worker(ctx context.Context, id int, jobs <-chan Job, results chan<- Result) {
    for job := range jobs {
        select {
        case <-ctx.Done():
            return
        default:
            results <- process(job)
        }
    }
}

func RunWorkers(ctx context.Context, jobs []Job, numWorkers int) []Result {
    jobCh := make(chan Job, len(jobs))
    resultCh := make(chan Result, len(jobs))

    // Start workers
    for i := range numWorkers {
        go worker(ctx, i, jobCh, resultCh)
    }

    // Send jobs
    for _, job := range jobs {
        jobCh <- job
    }
    close(jobCh)

    // Collect results
    results := make([]Result, 0, len(jobs))
    for range jobs {
        results = append(results, <-resultCh)
    }
    return results
}
```

### Context

```go
import "context"

// Context carries deadlines, cancellation signals, and request-scoped values

// With timeout
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

// With cancellation
ctx, cancel := context.WithCancel(context.Background())
defer cancel()
go func() {
    // Cancel on signal
    sigCh := make(chan os.Signal, 1)
    signal.Notify(sigCh, os.Interrupt)
    <-sigCh
    cancel()
}()

// With values
ctx := context.WithValue(context.Background(), "request_id", reqID)

// Check cancellation
select {
case <-ctx.Done():
    return ctx.Err()
default:
}
```

## HTTP services

### Standard library

```go
import (
    "encoding/json"
    "log"
    "net/http"
)

type Server struct {
    storage Storage
}

func NewServer(storage Storage) *Server {
    return &Server{storage: storage}
}

func (s *Server) handleGetUser(w http.ResponseWriter, r *http.Request) {
    id, err := strconv.ParseInt(r.PathValue("id"), 10, 64)
    if err != nil {
        http.Error(w, "invalid id", http.StatusBadRequest)
        return
    }

    user, err := s.storage.Get(r.Context(), id)
    if err != nil {
        if errors.Is(err, ErrNotFound) {
            http.Error(w, "not found", http.StatusNotFound)
            return
        }
        log.Printf("error getting user: %v", err)
        http.Error(w, "internal error", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(user)
}

func (s *Server) Run(addr string) error {
    mux := http.NewServeMux()
    mux.HandleFunc("GET /users/{id}", s.handleGetUser)
    mux.HandleFunc("POST /users", s.handleCreateUser)

    // Middleware
    handler := withLogging(withCORS(mux))

    return http.ListenAndServe(addr, handler)
}

// Middleware pattern
func withLogging(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Printf("%s %s", r.Method, r.URL.Path)
        next.ServeHTTP(w, r)
    })
}
```

### Popular router (chi)

```go
import "github.com/go-chi/chi/v5"

func (s *Server) Routes() chi.Router {
    r := chi.NewRouter()
    r.Use(middleware.Logger)
    r.Use(middleware.Recoverer)
    r.Use(middleware.Timeout(30 * time.Second))

    r.Route("/users", func(r chi.Router) {
        r.Get("/", s.handleListUsers)
        r.Post("/", s.handleCreateUser)
        r.Route("/{id}", func(r chi.Router) {
            r.Get("/", s.handleGetUser)
            r.Put("/", s.handleUpdateUser)
            r.Delete("/", s.handleDeleteUser)
        })
    })
    return r
}
```

## Testing

```go
import (
    "testing"
    "net/http/httptest"
)

// Table-driven tests
func TestAdd(t *testing.T) {
    tests := []struct {
        name string
        a, b int
        want int
    }{
        {"positive", 2, 3, 5},
        {"negative", -1, 1, 0},
        {"zero", 0, 0, 0},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := Add(tt.a, tt.b)
            if got != tt.want {
                t.Errorf("Add(%d, %d) = %d; want %d", tt.a, tt.b, got, tt.want)
            }
        })
    }
}

// HTTP test
func TestHandleGetUser(t *testing.T) {
    storage := newMockStorage()
    srv := NewServer(storage)
    handler := srv.Routes()

    req := httptest.NewRequest("GET", "/users/1", nil)
    rec := httptest.NewRecorder()
    handler.ServeHTTP(rec, req)

    if rec.Code != http.StatusOK {
        t.Errorf("got status %d; want %d", rec.Code, http.StatusOK)
    }
}

// Subtest with cleanup
func TestWithFile(t *testing.T) {
    tmpDir := t.TempDir()
    // Automatically cleaned up after test
}

// Benchmark
func BenchmarkAdd(b *testing.B) {
    for range b.N {
        Add(1, 2)
    }
}
```

### Test helpers

```go
// testutil/testutil.go
func AssertEqual(t *testing.T, got, want any) {
    t.Helper()
    if !reflect.DeepEqual(got, want) {
        t.Errorf("got %v; want %v", got, want)
    }
}

func AssertNoError(t *testing.T, err error) {
    t.Helper()
    if err != nil {
        t.Fatalf("unexpected error: %v", err)
    }
}
```

## Common patterns

### Option pattern (functional options)

```go
type ServerOption func(*Server)

func WithTimeout(t time.Duration) ServerOption {
    return func(s *Server) {
        s.timeout = t
    }
}

func WithMaxConnections(n int) ServerOption {
    return func(s *Server) {
        s.maxConns = n
    }
}

func NewServer(addr string, opts ...ServerOption) *Server {
    s := &Server{
        addr:    addr,
        timeout: 30 * time.Second,
    }
    for _, opt := range opts {
        opt(s)
    }
    return s
}
```

### Cleanup via defer

```go
func ProcessFile(path string) error {
    f, err := os.Open(path)
    if err != nil {
        return err
    }
    defer f.Close()  // Runs when function returns

    // ... process file
}
```

### Once pattern

```go
var (
    initOnce sync.Once
    config   *Config
)

func GetConfig() *Config {
    initOnce.Do(func() {
        config = loadConfig()
    })
    return config
}
```

## Common pitfalls

- **Unused imports and variables**: Won't compile. Use `_ = varName` or remove them.
- **`nil` map writes**: `var m map[string]int; m["key"] = 1` panics. Initialize with `make()`.
- **`nil` slice append**: `var s []int; s = append(s, 1)` works fine (append handles nil).
- **Goroutine leaks**: A goroutine blocked on channel send without a receiver leaks. Always ensure goroutines can exit.
- **`defer` inside loops**: `defer` runs at function return, not loop iteration. Don't defer in loops.
- **Copying `sync.Mutex`**: Mutexes must not be copied. Always use `*sync.Mutex`.
- **`range` variable capture**: `for _, v := range items { go func() { fmt.Println(v) }() }` — all goroutines see the last `v`. Pass as argument.
- **Interface nil vs typed nil**: `var buf *bytes.Buffer; var w io.Writer = buf; w == nil` is false (interface has type info). Check before assigning.

## Tooling

```bash
go fmt ./...              # Format all code
go vet ./...              # Static analysis
go mod tidy               # Clean up dependencies
go mod verify             # Verify dependencies haven't been tampered with
go test -race ./...       # Run tests with race detector
go test -cover ./...      # Coverage report
go build -o server ./cmd/server  # Build
golangci-lint run         # Comprehensive linter
pprof                     # CPU/memory profiling
```

## Reference

- [Go Documentation](https://go.dev/doc/)
- [Effective Go](https://go.dev/doc/effective_go)
- [Go by Example](https://gobyexample.com/)
- [Go Modules Reference](https://go.dev/ref/mod)
- [Go Blog](https://go.dev/blog/)
- [Standard Go Project Layout](https://github.com/golang-standards/project-layout)
