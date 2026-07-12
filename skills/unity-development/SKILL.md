---
name: "unity-development"
description: "Build games and applications with Unity 6 — C# scripting, MonoBehaviour lifecycle, physics, input, UI Toolkit, ScriptableObjects, coroutines, async/await, addressables, ECS/DOTS, shader graph, and performance optimization."
---

# Unity Development

> Build games and applications with Unity 6 — C# scripting, MonoBehaviour lifecycle, physics, input, UI Toolkit, ScriptableObjects, coroutines, async/await, addressables, ECS/DOTS, shader graph, and performance optimization.

## When to use

Use this skill when working with Unity: writing C# scripts, setting up game objects and components, handling input and physics, building UI, creating ScriptableObject systems, optimizing performance, using the Addressable system, working with ECS/DOTS, or writing shaders.

## Core architecture

- **Entity-Component pattern** — GameObjects are containers; Components (MonoBehaviours) add behavior. A GameObject is useless without components.
- **Scene-based editing** — Scenes contain the object hierarchy. Everything lives in a scene at runtime.
- **Serialization-driven** — Unity serializes public and `[SerializeField]` fields. The inspector is a serialization viewer.
- **Frame-based lifecycle** — The `Update()` loop drives most game logic. Fixed timestep for physics (`FixedUpdate`), frame-based for visuals (`Update`, `LateUpdate`).
- **Prefab workflow** — Prefabs are reusable GameObject templates. Override individual properties per instance.
- **Data-oriented with DOTS** — Unity ECS (Entities 1.0+) provides a data-oriented alternative for performance-critical systems.

## MonoBehaviour lifecycle

Execution order within a frame:

```csharp
Awake()           // Called once on load, before Start. Use for self-initialization.
OnEnable()        // Called every time the object becomes enabled/active.
Reset()           // Called in editor when component is first added or Reset is clicked.
Start()           // Called once before first Update, after all Awakes.
FixedUpdate()     // Fixed timestep (default 0.02s). Use for physics and rigidbody work.
OnTriggerEnter()  // Physics trigger events (also: Stay, Exit).
OnCollisionEnter()// Physics collision events (also: Stay, Exit).
Update()          // Every frame. Main game logic loop.
LateUpdate()      // After all Updates. Camera follow, position smoothing.
OnDisable()       // Called when object becomes disabled.
OnDestroy()       // Called when object is destroyed.
OnApplicationQuit() // Called before app exits.

// Coroutines (run between Update and LateUpdate in most cases)
yield return null;          // Wait one frame
yield return new WaitForSeconds(1f);  // Wait scaled time
yield return new WaitForSecondsRealtime(1f); // Wait real time
yield return new WaitForEndOfFrame();  // After rendering
yield return new WaitForFixedUpdate(); // After physics
yield return new WaitUntil(() => condition); // Wait for predicate
yield return new WaitWhile(() => condition); // Wait while predicate
```

### Important lifecycle notes

- `Awake` and `Start` are not called on disabled components. `Awake` runs even if the component is disabled but the GameObject is active.
- `OnEnable`/`OnDisable` pair correctly with event (un)subscription.
- `FixedUpdate` can run 0, 1, or multiple times per frame depending on the fixed timestep vs frame time.
- Avoid `Find*` APIs in `Update` — cache references in `Awake`/`Start`.

## C# scripting fundamentals

### Component structure

```csharp
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    // Serialized fields appear in the Inspector
    [Header("Movement")]
    [SerializeField] private float moveSpeed = 5f;
    [SerializeField] private float jumpForce = 10f;

    [Header("References")]
    [SerializeField] private Rigidbody rb;
    [SerializeField] private Transform cameraTransform;

    // Public but [NonSerialized] — hidden in inspector
    [NonSerialized] public bool IsGrounded;

    // Auto-property with inspector exposure
    public int Health { get; private set; } = 100;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
        Cursor.lockState = CursorLockMode.Locked;
    }

    private void Update()
    {
        HandleInput();
    }

    private void FixedUpdate()
    {
        Move();
    }

    private void HandleInput()
    {
        if (Input.GetButtonDown("Jump") && IsGrounded)
        {
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
        }
    }

    private void Move()
    {
        float x = Input.GetAxis("Horizontal");
        float z = Input.GetAxis("Vertical");
        Vector3 move = (cameraTransform.right * x + cameraTransform.forward * z).normalized;
        rb.linearVelocity = new Vector3(move.x * moveSpeed, rb.linearVelocity.y, move.z * moveSpeed);
    }
}
```

### Attributes

```csharp
[SerializeField]           // Expose private field to inspector
[NonSerialized]            // Hide public field from inspector
[HideInInspector]          // Hide even public field
[Range(0, 10)]             // Slider in inspector
[Min(0)]                   // Minimum value
[Tooltip("Description")]   // Tooltip on hover
[Header("Section")]        // Section header
[Space(10)]                // Vertical spacing
[TextArea(3, 10)]          // Multi-line text field
[ColorUsage(true, true)]   // Color picker with HDR
[RequireComponent(typeof(Rigidbody))] // Auto-add required component
[ExecuteAlways]            // Run in edit mode too
[DefaultExecutionOrder(-100)] // Control script execution order
[CreateAssetMenu]          // Create ScriptableObject via Assets menu
[ContextMenu("Do Thing")]  // Right-click context menu on component
```

### Debugging

```csharp
Debug.Log("Message");              // Info
Debug.LogWarning("Warning");       // Yellow warning
Debug.LogError("Error");           // Red error
Debug.DrawLine(a, b, Color.red);   // Editor-only line (Scene view)
Debug.Break();                     // Pause editor
Debug.Assert(condition, "msg");    // Assertion
Debug.Log($"<color=green>{value}</color>"); // Rich text in console
```

## Input system

### New Input System (recommended, `UnityEngine.InputSystem`)

```csharp
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerInput : MonoBehaviour
{
    private PlayerActions actions;  // Generated from .inputactions asset
    private Vector2 moveInput;
    private bool jumpPressed;

    private void Awake()
    {
        actions = new PlayerActions();
    }

    private void OnEnable()
    {
        actions.Player.Enable();
        actions.Player.Jump.performed += OnJump;
    }

    private void OnDisable()
    {
        actions.Player.Disable();
        actions.Player.Jump.performed -= OnJump;
    }

    private void Update()
    {
        moveInput = actions.Player.Move.ReadValue<Vector2>();
    }

    private void OnJump(InputAction.CallbackContext context)
    {
        if (context.performed) Jump();
    }
}
```

### Legacy Input Manager

```csharp
Input.GetAxis("Horizontal");           // -1 to 1, smoothed
Input.GetAxisRaw("Horizontal");        // -1, 0, or 1, raw
Input.GetButton("Jump");               // Held
Input.GetButtonDown("Jump");           // Pressed this frame
Input.GetButtonUp("Jump");             // Released this frame
Input.GetKey(KeyCode.Space);           // Specific key
Input.mousePosition;                   // Screen-space mouse
Input.GetMouseButton(0);               // 0=left, 1=right, 2=middle
```

## Physics

### Rigidbody (3D physics)

```csharp
rb.linearVelocity = direction * speed;        // Set velocity directly
rb.AddForce(force, ForceMode.Force);          // Continuous force (F=ma)
rb.AddForce(force, ForceMode.Impulse);        // Instant impulse
rb.AddTorque(torque, ForceMode.Force);        // Rotation force
rb.AddExplosionForce(power, origin, radius);  // Explosion
rb.MovePosition(targetPos);                   // Use in FixedUpdate for smooth movement
rb.MoveRotation(targetRot);                   // Use in FixedUpdate
```

### Collision & triggers

```csharp
// Collision events
private void OnCollisionEnter(Collision collision) { }
private void OnCollisionStay(Collision collision) { }
private void OnCollisionExit(Collision collision) { }

// Trigger events (requires IsTrigger enabled)
private void OnTriggerEnter(Collider other) { }
private void OnTriggerStay(Collider other) { }
private void OnTriggerExit(Collider other) { }

// Contact info
collision.contacts[0].point;     // Contact position
collision.relativeVelocity;      // Impact velocity
collision.gameObject;            // Other GameObject
collision.transform;             // Other Transform
```

### Physics 2D (`Rigidbody2D`, `Collider2D`)

Same pattern with `Rigidbody2D` and `Collider2D`. Use `OnCollisionEnter2D`, `OnTriggerEnter2D`, etc.

### Raycasting

```csharp
// 3D
if (Physics.Raycast(origin, direction, out RaycastHit hit, maxDistance, layerMask))
{
    hit.point;      // World position
    hit.normal;     // Surface normal
    hit.transform;  // Hit object
    hit.collider;   // Hit collider
}

// Sphere cast, box cast, capsule cast
Physics.SphereCast(origin, radius, direction, out hit, maxDistance);
Physics.BoxCast(center, halfExtents, direction, out hit, rotation, maxDistance);

// Non-allocating variants for performance
RaycastHit[] hits = new RaycastHit[10];
int count = Physics.RaycastNonAlloc(origin, direction, hits, maxDistance);

// 2D
if (Physics2D.Raycast(origin, direction, maxDistance, layerMask))
```

### Layer-based collision

```csharp
int layerMask = LayerMask.GetMask("Player", "Enemy");  // By name
int layerMask = 1 << LayerMask.NameToLayer("Enemy");   // Bit shift
```

## Coroutines & async

### Coroutines

```csharp
private IEnumerator MyCoroutine()
{
    // Start
    yield return new WaitForSeconds(1f);
    // After 1 second
    yield return null;
    // Next frame
}

// Start/Stop
Coroutine coroutine = StartCoroutine(MyCoroutine());
StopCoroutine(coroutine);
StopAllCoroutines();
```

### Async/await (Unity 6+, `Awaitable`)

```csharp
using UnityEngine;

public class AsyncExample : MonoBehaviour
{
    private async Awaitable Start()
    {
        await Awaitable.WaitForSecondsAsync(1f);
        await Awaitable.NextFrameAsync();
        await Awaitable.EndOfFrameAsync();
        await Awaitable.FixedUpdateAsync();

        // Parallel
        await Awaitable.WhenAll(Task1(), Task2());
    }

    private async Awaitable Task1() { /* ... */ }
    private async Awaitable Task2() { /* ... */ }
}
```

## ScriptableObjects

ScriptableObjects are data containers that avoid duplication and enable modular architectures.

```csharp
[CreateAssetMenu(fileName = "ItemData", menuName = "Game/Item Data")]
public class ItemData : ScriptableObject
{
    public string itemName;
    public Sprite icon;
    public int maxStack = 99;
    [TextArea] public string description;

    // Runtime data — reset when entering play mode
    [NonSerialized] public int currentStack;
}
```

### Event channel pattern

```csharp
[CreateAssetMenu(menuName = "Events/Void Event Channel")]
public class VoidEventChannelSO : ScriptableObject
{
    public event System.Action OnEventRaised;

    public void RaiseEvent() => OnEventRaised?.Invoke();
}

// Usage: two SO references — one for raising, one for listening
// Decouples sender and receiver completely
```

## UI Toolkit (UIE) — modern UI

Unity's runtime UI system (replaces uGUI for new projects, especially in Unity 6).

```csharp
using UnityEngine;
using UnityEngine.UIElements;

public class HUDController : MonoBehaviour
{
    [SerializeField] private UIDocument document;
    private Label healthLabel;
    private Button restartButton;

    private void OnEnable()
    {
        var root = document.rootVisualElement;
        healthLabel = root.Q<Label>("HealthValue");
        restartButton = root.Q<Button>("RestartButton");

        restartButton.clicked += OnRestartClicked;
    }

    private void OnRestartClicked()
    {
        // Handle restart
    }

    public void SetHealth(int health)
    {
        healthLabel.text = health.ToString();
    }
}
```

### USS (Unity Style Sheet) — UI styling

```css
/* Styles.uss */
.button-primary {
    background-color: rgb(60, 120, 200);
    color: white;
    font-size: 18px;
    border-radius: 4px;
    padding: 8px 16px;
}

.button-primary:hover {
    background-color: rgb(80, 150, 230);
}
```

## Addressables

Asset management system for loading/unloading content at runtime.

```csharp
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;

public class AssetLoader : MonoBehaviour
{
    [SerializeField] private AssetReferenceGameObject enemyPrefab;
    [SerializeField] private AssetReferenceSprite iconRef;

    private async void Start()
    {
        // Load a single asset
        var handle = Addressables.LoadAssetAsync<GameObject>("Assets/Prefabs/Enemy.prefab");
        GameObject prefab = await handle.Task;
        Instantiate(prefab);

        // Load via AssetReference
        GameObject enemy = await enemyPrefab.InstantiateAsync(transform.position, Quaternion.identity).Task;

        // Release when done
        Addressables.Release(handle);

        // Instantiate + auto-release with InstantiateAsync
        var op = enemyPrefab.InstantiateAsync(position, rotation);
        var instance = await op.Task;  // Released with op.Release()

        // Load multiple
        var locations = await Addressables.LoadResourceLocationsAsync("tag:enemies").Task;
    }

    private void OnDestroy()
    {
        // Clean up all Addressables operations
        Addressables.ReleaseInstance(gameObject);
    }
}
```

## ECS / DOTS (Entities 1.0+)

Data-Oriented Technology Stack for high-performance systems.

```csharp
using Unity.Entities;
using Unity.Transforms;
using Unity.Mathematics;

// Component — pure data (no methods)
public struct Velocity : IComponentData
{
    public float3 Value;
}

// System — processes entities
public partial struct MovementSystem : ISystem
{
    public void OnUpdate(ref SystemState state)
    {
        foreach (var (transform, velocity) in
                 SystemAPI.Query<RefRW<LocalTransform>, RefRO<Velocity>>())
        {
            transform.ValueRW.Position += velocity.ValueRO.Value * SystemAPI.Time.DeltaTime;
        }
    }
}

// Baking — converts GameObject to ECS
public class VelocityAuthoring : MonoBehaviour
{
    public float3 velocity;
}

public class VelocityBaker : Baker<VelocityAuthoring>
{
    public override void Bake(VelocityAuthoring authoring)
    {
        AddComponent(new Velocity { Value = authoring.velocity });
    }
}
```

## Common patterns

### Singleton

```csharp
public class GameManager : MonoBehaviour
{
    private static GameManager instance;
    public static GameManager Instance => instance;

    private void Awake()
    {
        if (instance != null && instance != this)
        {
            Destroy(gameObject);
            return;
        }
        instance = this;
        DontDestroyOnLoad(gameObject);
    }
}
```

### Object pooling

```csharp
public class ObjectPool : MonoBehaviour
{
    [SerializeField] private GameObject prefab;
    [SerializeField] private int initialSize = 10;
    private Queue<GameObject> pool = new();

    private void Awake()
    {
        for (int i = 0; i < initialSize; i++)
        {
            var obj = CreateNew();
            pool.Enqueue(obj);
        }
    }

    public GameObject Get()
    {
        if (pool.Count == 0) return CreateNew();
        var obj = pool.Dequeue();
        obj.SetActive(true);
        return obj;
    }

    public void Return(GameObject obj)
    {
        obj.SetActive(false);
        pool.Enqueue(obj);
    }

    private GameObject CreateNew()
    {
        var obj = Instantiate(prefab, transform);
        obj.SetActive(false);
        return obj;
    }
}
```

### State machine

```csharp
public abstract class BaseState
{
    public abstract void Enter();
    public abstract void Update();
    public abstract void Exit();
}

public class StateMachine
{
    public BaseState CurrentState { get; private set; }

    public void ChangeState(BaseState newState)
    {
        CurrentState?.Exit();
        CurrentState = newState;
        CurrentState.Enter();
    }

    public void Update() => CurrentState?.Update();
}
```

### Service locator / DI

```csharp
public static class Services
{
    private static Dictionary<Type, object> services = new();

    public static void Register<T>(T service) where T : class
        => services[typeof(T)] = service;

    public static T Get<T>() where T : class
        => services.TryGetValue(typeof(T), out var s) ? s as T : null;
}
```

## Performance optimization

### General rules
- Cache `GetComponent` and `transform` in `Awake`/`Start`
- Use `CompareTag` instead of `gameObject.CompareTag` (same thing) or better, use layers
- Avoid `Find`, `FindObjectOfType`, `FindGameObjectsWithTag` in hot paths
- Use object pooling for frequently spawned/destroyed objects
- Use `TryGetComponent` instead of `GetComponent` + null check
- Prefer `NonAlloc` variants (`RaycastNonAlloc`, etc.)
- Use `PhysicsScene` for multi-scene physics
- Disable `Auto Sync Transforms` if you don't need it

### GC avoidance
```csharp
// Avoid allocation in Update
// Bad:
void Update() { Debug.DrawLine(transform.position, target.position, Color.red); }

// Good (cache the color):
Color debugColor = Color.red;
void Update() { Debug.DrawLine(transform.position, target.position, debugColor); }

// Use StringBuilder for string concatenation in hot paths
// Use ArrayPool for temporary arrays
// Cache WaitForSeconds instances instead of creating new ones
// Avoid foreach on List<T> (allocates enumerator)
```

### Profiling tools

```csharp
Profiler.BeginSample("MyHeavyMethod");
// ... work ...
Profiler.EndSample();
```

## ShaderGraph & shaders

### Built-in shader property types

| Type | Example |
|------|---------|
| `_Color` | `Color` |
| `_MainTex` | `Texture2D` |
| `_Glossiness` | `Range(0,1)` |
| `_Vector` | `Vector4` |
| `_Float` | `Float` |

### Simple unlit shader (HLSL)

```hlsl
Shader "Custom/UnlitColor"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
            };

            float4 _Color;

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
```

## Build & project settings

### Player settings essentials

```csharp
// Scripting backend: IL2CPP (recommended for release builds)
// Api Compatibility: .NET Standard 2.1 or .NET 4.x
// Color Space: Linear (for physically-based rendering)
// Graphics APIs: Vulkan/Direct3D12 (preferred), Metal on macOS/iOS
// Managed Stripping Level: Low (during dev), Medium/High (for release)
```

### Common project organization

```
Assets/
├── Art/           # Models, textures, materials, shaders
│   ├── Models/
│   ├── Textures/
│   ├── Materials/
│   └── Shaders/
├── Audio/         # Sound effects, music, audio mixers
├── Prefabs/       # Reusable prefab assets
├── Scenes/        # Scene files
├── Scripts/       # C# source code
│   ├── Behaviors/  # MonoBehaviour components
│   ├── ScriptableObjects/
│   ├── Systems/    # Manager/service classes
│   └── Utilities/  # Helper/extension classes
├── UI/            # UXML, USS, UI assets
└── Resources/     # Runtime-loaded assets (use Addressables instead)
```

## Pitfalls & gotchas

- **`transform` vs `GetComponent<Transform>`**: `transform` is cached per `GameObject`. Access is cheap. But `transform.position` sets the local position if there's no parent.
- **`Destroy()` is deferred**: Destroyed objects remain valid until end of frame. Check with `== null` (which is overridden).
- **`FindObjectOfType` is slow**: Avoid in `Update`. Cache in `Awake`/`Start`.
- **`Resources.Load` is discouraged**: Use Addressables for runtime loading.
- **`OnValidate()` runs in editor**: Called when a serialized field changes. Good for validation, bad for expensive operations.
- **Animator parameters**: Cache parameter hashes with `Animator.StringToHash`.
- **`FixedUpdate` and `Update` timing**: Never rely on specific call order between different objects' `FixedUpdate` or `Update`. Use execution order or a manager pattern.
- **`Time.timeScale = 0` pauses everything**: Coroutines using `WaitForSeconds`, `Update`, and `FixedUpdate` are all affected. Use `WaitForSecondsRealtime` for UI.
- **`Debug.Log` in builds**: Strip debug logs in release builds via `#if UNITY_EDITOR`.
- **IL2CPP limitations**: Some reflection patterns break. `Expression.Compile`, runtime code generation, and serialization callbacks need care.
- **Mobile**: Use mesh combine, texture atlases, disable shadows, reduce draw calls. Profile on device early.
- **`transform.SetParent(null)` vs `transform.parent = null`**: They're the same. Use `SetParent` with `worldPositionStays` parameter.
- **Quaternion multiplication order**: `result = a * b` means "rotate by `a`, then by `b` in local space." Order matters.

## Reference

- [Unity Scripting API](https://docs.unity3d.com/ScriptReference/)
- [Unity Manual](https://docs.unity3d.com/Manual/)
- [Unity Learn](https://learn.unity.com/)
- [Unity Asset Store](https://assetstore.unity.com/)
- [Unity Discussions](https://discussions.unity.com/)
- [Unity Issue Tracker](https://issuetracker.unity3d.com/)
