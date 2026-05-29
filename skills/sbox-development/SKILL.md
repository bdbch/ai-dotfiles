---
name: "S&box Development"
description: "Build games and experiences with S&box by Facepunch — C# game code, entities, components, input, UI (Razor/SCSS), networking, physics, asset management, gamemodes, and the S&box editor."
---

# S&box Development

> Build games and experiences with S&box by Facepunch — C# game code, entities, components, input, UI (Razor/SCSS), networking, physics, asset management, gamemodes, and the S&box editor.

## When to use

Use this skill when working with S&box: writing game code in C#, creating entities and components, setting up gamemodes, building UI with Razor/SCSS, handling input and networking, working with the S&box asset system, or extending the editor.

## Core architecture

- **Entity-Component System** — Everything in the world is an `Entity`. Components attach behavior. `GameObject` is the base for placed entities with a transform.
- **Gamemode-driven** — Gamemodes define game rules, spawning, and round logic. A single gamemode is active at a time, defined by a `.gamemode` file.
- **C# as the primary language** — All game code is C#. The engine is written in C++ but exposed via C# bindings.
- **Event-driven** — S&box uses a global event system (`Event.Register`/`Event.Run`) for decoupled communication between systems.
- **Razor UI** — UI is built using `.razor` files (HTML-like syntax) with SCSS styling and C# code-behind. This is Blazor-based.
- **Deterministic networking** — Entities are either server-side only or networked automatically via `[Net]` attributes on properties.

## Getting started

The basic structure of an S&box project:

```
MyGame/
├── code/
│   ├── MyGame.cs              # Entry point / gamemode
│   ├── Entities/              # Entity definitions
│   ├── Components/            # Component definitions
│   ├── UI/                    # Razor UI files
│   └── Gamemodes/             # Gamemode logic
├── materials/                 # Material files (.vmat)
├── models/                    # Model files (.vmdl)
├── textures/                  # Texture files (.vtex)
├── sounds/                    # Sound files (.vsnd)
├── scenes/                    # Scene files (.scene)
├── ui/                        # Static UI assets (CSS, images)
├── shaders/                   # Shader files
└── project.txt                # Project manifest
```

### Project manifest

```json
{
  "Title": "My Game",
  "Description": "An amazing S&box experience",
  "Ident": "myname.mygame",
  "Version": 1,
  "Creator": "YourName",
  "GameType": "multiplayer",
  "Gamemodes": ["sandbox", "mygamemode"]
}
```

## Entity system

### Base entity class

```csharp
using Sandbox;

public class MyEntity : Entity
{
    // Lifecycle
    public override void Spawn()
    {
        base.Spawn();
        // Called when entity is created/spawned
    }

    public override void ClientSpawn()
    {
        base.ClientSpawn();
        // Called on client when entity is created
    }

    protected override void OnDestroy()
    {
        base.OnDestroy();
        // Cleanup when entity is destroyed
    }

    // Ticking
    [Event.Tick.Server]
    private void OnServerTick()
    {
        // Called every tick on server (16.66ms intervals)
    }

    [Event.Tick.Client]
    private void OnClientTick()
    {
        // Called every frame on client
    }

    // Simulation
    public override void Simulate(IClient cl)
    {
        base.Simulate(cl);
        // Called on server for each client's simulation
    }

    public override void FrameSimulate(IClient cl)
    {
        base.FrameSimulate(cl);
        // Called on client for prediction
    }
}
```

### Game object (entity with transform, preferred for placed things)

```csharp
public class MyProp : Component
{
    // Model
    [Property] public Model Model { get; set; }

    protected override void OnStart()
    {
        if (Model != null)
        {
            Components.Get<ModelRenderer>(FindMode.EverythingInSelf).Model = Model;
        }
    }

    protected override void OnUpdate()
    {
        // Called every frame
        Transform.Position += Vector3.Up * Time.Delta * 50f;
    }
}
```

> Note: S&box has transitioned from the old `Entity`-as-base system to a `GameObject`/`Component` model. `GameObject` is the scene object with a transform; `Component` attaches behavior. Use `Component` for most gameplay code.

### Available component attributes

```csharp
[Property]     // Exposed in editor
[Sync]         // Synchronized over network
[HideInEditor] // Hidden in editor
[Description("Does something")] // Tooltip
[Range(0, 100)] // Slider in editor
[Category("Movement")] // Group in editor
```

### Common built-in components

```csharp
ModelRenderer     // Renders a 3D model
ModelCollider     // Collision shape matching a model
BoxCollider       // Box collision
SphereCollider    // Sphere collision
Rigidbody         // Physics body
NavMeshAgent      // AI pathfinding
PlayerController  // Character movement
```

## Gamemodes

```csharp
using Sandbox;
using Sandbox.UI;

public partial class MyGame : Sandbox.Game
{
    public MyGame()
    {
        // Called when the gamemode starts
    }

    public override void ClientJoined(IClient client)
    {
        base.ClientJoined(client);

        // Spawn player pawn
        var pawn = new MyPlayer();
        client.Pawn = pawn;
        pawn.Spawn();
    }

    public override void ClientDisconnect(IClient client)
    {
        base.ClientDisconnect(client);
    }

    public override void Simulate(IClient cl)
    {
        base.Simulate(cl);
        // Game logic ticks here
    }

    protected override void OnDestroy()
    {
        base.OnDestroy();
        // Cleanup
    }
}
```

## Input handling

```csharp
public class MyPlayer : Component
{
    protected override void OnUpdate()
    {
        // Keyboard
        if (Input.Down("forward")) MoveForward();
        if (Input.Pressed("jump")) Jump();
        if (Input.Released("sprint")) StopSprint();

        // Mouse
        if (Input.Down("attack1")) Fire();
        if (Input.Pressed("reload")) Reload();

        // Raw input
        var move = Input.AnalogMove;  // Vector2 for WASD
        var look = Input.AnalogLook;  // Vector2 for mouse

        // Screen position
        Vector2 mousePos = Input.MousePosition;
        Ray screenRay = Input.ScreenRay;  // 3D ray from camera through mouse
    }
}

// Input actions are defined in the project's input configuration
// Common built-in actions: forward, backward, left, right, jump, sprint,
// attack1, attack2, reload, use, walk, duck, zoom, menu
```

## Networking

```csharp
public class NetworkedEntity : Component
{
    // [Sync] auto-replicates from server to all clients
    [Sync] public int Score { get; set; }

    [Sync] public string PlayerName { get; set; }

    // [Sync] with hooks
    private int health;
    [Sync]
    public int Health
    {
        get => health;
        set
        {
            health = value;
            OnHealthChanged();
        }
    }

    private void OnHealthChanged()
    {
        // Called on both server and client when value changes
    }

    // RPCs (Remote Procedure Calls)
    [ConCmd.Server("mycommand_fire")]
    public static void FireWeapon()
    {
        // Runs on server, called from client
        var caller = ConsoleSystem.Caller;
    }

    [ClientRpc]
    public void PlayEffect(Vector3 position)
    {
        // Runs on all clients
        Particles.Create("effects/muzzle_flash", position);
    }
}
```

### Networking patterns

- `[Sync]` — Auto-replicated properties (server → clients)
- `[ConCmd.Server]` — Client-to-server RPC (called from client, runs on server)
- `[ClientRpc]` — Server-to-client broadcast
- `[Broadcast]` — Runs on both server and all clients
- Prediction: `Simulate(IClient)` runs predicted code. `FrameSimulate` is for visual smoothing.

## UI with Razor

S&box uses Blazor-style Razor components for UI. Files are `.razor` with optional code-behind.

### Basic component

```html
@* MyHud.razor *@
<style>
    .hud {
        position: absolute;
        bottom: 40px;
        left: 50%;
        transform: translateX(-50%);
        font-family: 'Poppins', sans-serif;
        color: white;
        text-shadow: 1px 1px 2px rgba(0,0,0,0.8);
    }
    .health {
        font-size: 48px;
        font-weight: bold;
    }
    .ammo {
        font-size: 24px;
    }
</style>

<div class="hud">
    <div class="health">@Health</div>
    <div class="ammo">@Ammo / @MaxAmmo</div>
</div>

@code {
    [Property] public int Health { get; set; } = 100;
    [Property] public int Ammo { get; set; } = 30;
    [Property] public int MaxAmmo { get; set; } = 30;

    protected override void OnUpdate()
    {
        // Update from local player state
        if (Game.LocalPawn is MyPlayer player)
        {
            Health = player.Health;
        }
    }
}
```

### Root HUD

```csharp
// HUD.razor — Root UI component
@* Loads as the main HUD *@
<MyHud />
```

### UI lifecycle

```csharp
protected override void OnStart()    // First frame
protected override void OnUpdate()   // Every frame
protected override void OnDestroy()  // Cleanup
```

### Panel-based UI (legacy, still common)

```csharp
public class MyHud : Panel
{
    public MyHud()
    {
        StyleSheet.Load("/ui/MyHud.scss");
    }

    public override void Tick()
    {
        base.Tick();
        // Update UI state
    }
}
```

## Physics

```csharp
public class PhysicsObject : Component
{
    [Property] public Rigidbody Rigidbody { get; set; }

    protected override void OnStart()
    {
        // Apply force
        Rigidbody.ApplyForce(Vector3.Up * 1000f);

        // Apply impulse
        Rigidbody.ApplyImpulse(Vector3.Forward * 500f);

        // Set velocity
        Rigidbody.Velocity = new Vector3(0, 0, 100);

        // Set body type
        Rigidbody.BodyType = PhysicsBodyType.Dynamic; // or Static, Kinematic
    }

    private void OnTriggerEnter(Collider other)
    {
        Log.Info($"Triggered by: {other.GameObject.Name}");
    }

    private void OnCollisionEnter(Collision collision)
    {
        Log.Info($"Hit: {collision.Other.GameObject.Name} at {collision.Contact.Point}");
    }
}
```

## Sound

```csharp
// Play a sound at a position
Sound.Play("sounds/my_sound.vsnd", Transform.Position);

// Play on an entity (follows it)
Sound s = Sound.Play("sounds/ambient.vsnd", GameObject);
s.Volume = 0.5f;
s.Pitch = 1.2f;

// Stop
s.Stop();

// One-shot UI sound
Sound.Play("sounds/ui_click.vsnd");
```

## Particles

```csharp
// Spawn at position
Particles.Create("particles/explosion.vpcf", Transform.Position);

// Spawn attached to an entity
Particles p = Particles.Create("particles/fire.vpcf", GameObject, "fire_attach");
p.Destroy(false);  // false = don't destroy immediately

// Control
p.SetPosition(0, Vector3.Zero);
p.SetForward(0, Vector3.Up);
```

## Events

```csharp
// Register a global event
Event.Register("my.custom.event");

// Fire an event
Event.Run("my.custom.event", someData);

// Listen (with method attribute)
public class MyListener : Component
{
    [Event("my.custom.event")]
    private void OnMyEvent()
    {
        // Handle event
    }
}

// Built-in game events
[Event.Hotload]         // Code was hot-reloaded
[Event.Tick.Server]     // Server tick
[Event.Tick.Client]     // Client frame
[Event.Entity.PostSpawn] // Entity spawned
```

## Console commands & variables

```csharp
// ConVar (console variable)
[ConVar("mygame_gravity")]
public static float Gravity { get; set; } = 800f;

// ConCmd (console command)
[ConCmd.Server("mygame_spawn")]
public static void SpawnEntity()
{
    var entity = new MyEntity();
    entity.Spawn();
}

[ConCmd.Client("mygame_cl_showhud")]
public static void ShowHud(int show)
{
    Local.Hud.Enabled = show != 0;
}

[ConCmd.Admin("mygame_kickall")]
public static void KickAll()
{
    // Admin-only command
}

// Accessing ConVars
float grav = ConVars.GetValue("mygame_gravity");
ConVars.SetValue("mygame_gravity", 400f);
```

## Logging & debug

```csharp
Log.Info("Message");
Log.Warning("Warning");
Log.Error("Error");
Log.Trace("Verbose debug");

// In-game debug overlay
DebugOverlay.ScreenText("Hello", 0);
DebugOverlay.Line(start, end, Color.Red, 5f, true);
DebugOverlay.Sphere(center, radius, Color.Green, 5f);
DebugOverlay.Box(center, size, rotation, Color.Blue, 5f);
DebugOverlay.Axis(transform, 5f);
```

## Resource system

```csharp
// Load assets by path
Model model = Model.Load("models/player/citizen.vmdl");
Material material = Material.Load("materials/example.vmat");
SoundEvent sound = SoundEvent.Load("sounds/shoot.vsnd");

// Precache in Spawn()
public override void Spawn()
{
    base.Spawn();
    Precache.Add("models/player/citizen.vmdl");
}
```

## Filesystem & data

```csharp
// Read/write persistent data
FileSystem.Data.WriteAllText("saves/player.json", jsonData);
string json = FileSystem.Data.ReadAllText("saves/player.json");

// Read game files
string content = FileSystem.Mounted.ReadAllText("data/config.json");

// Check existence
if (FileSystem.Data.FileExists("saves/player.json")) { }
```

## Editor tools

S&box includes a Hammer-like editor for building levels.

- **Scene editor** — Place entities, edit properties, set up lighting
- **Model editor** — Import, rig, and animate models
- **Material editor** — Create and edit materials with node graphs
- **Particle editor** — Create particle effects
- **Sound editor** — Import and configure sounds

Scriptable editor tools can be created with:

```csharp
[EditorTool]
public class MyTool : EditorTool
{
    public override void OnUpdate()
    {
        // Custom editor behavior
    }
}
```

## Common patterns

### Player controller

```csharp
public partial class MyPlayer : Component
{
    [Sync] public float Health { get; set; } = 100;
    [Sync] public int Ammo { get; set; } = 30;

    [Property] public PlayerController Controller { get; set; }
    [Property] public CameraComponent Camera { get; set; }

    protected override void OnStart()
    {
        Controller ??= Components.Get<PlayerController>();
        Camera ??= Components.Get<CameraComponent>();
    }

    protected override void OnUpdate()
    {
        // Camera follows controller
        if (Camera != null && Controller != null)
        {
            Camera.Transform.Position = Controller.Transform.Position + Vector3.Up * 64;
            Camera.Transform.Rotation = Controller.EyeRotation;
        }
    }

    public void TakeDamage(float damage)
    {
        Health -= damage;
        if (Health <= 0) Die();
    }

    private void Die()
    {
        // Handle death
    }
}
```

### Weapon

```csharp
public partial class Weapon : Component
{
    [Property] public float FireRate { get; set; } = 0.1f;
    [Property] public int MaxAmmo { get; set; } = 30;
    [Property] public Model WorldModel { get; set; }

    [Sync] public int Ammo { get; set; }

    private TimeSince timeSinceFire;

    protected override void OnStart()
    {
        Ammo = MaxAmmo;
    }

    public bool CanFire() => Ammo > 0 && timeSinceFire > FireRate;

    [ClientRpc]
    public void Fire()
    {
        if (!CanFire()) return;
        Ammo--;
        timeSinceFire = 0;

        // Play effects
        Sound.Play("sounds/pistol_shoot.vsnd", Transform.Position);
        Particles.Create("particles/muzzle_flash.vpcf", Transform.Position);

        // Shoot ray from camera
        var ray = Game.LocalPawn.GetComponent<CameraComponent>().ScreenRay;
        var tr = Scene.Trace.Ray(ray.Position, ray.Position + ray.Forward * 10000)
            .WithAnyTags("solid", "player")
            .Run();

        if (tr.Hit && tr.GameObject.Components.Get<MyPlayer>() is MyPlayer victim)
        {
            victim.TakeDamage(20);
        }
    }
}
```

### Singleton manager

```csharp
public class GameManager : Component
{
    public static GameManager Instance { get; private set; }

    protected override void OnStart()
    {
        Instance = this;
    }

    protected override void OnDestroy()
    {
        Instance = null;
    }
}
```

## Pitfalls & gotchas

- **`Component.OnStart` vs `Component.OnUpdate`**: `OnStart` runs once when the component is first enabled. `OnUpdate` runs every frame. Don't put heavy init in `OnUpdate`.
- **`[Sync]` properties are server-authoritative**: Clients can't set `[Sync]` values directly — use `[ConCmd.Server]` RPCs.
- **Prediction**: Code in `Simulate` runs on both server and client. Use `Game.IsServer` / `Game.IsClient` to differentiate when needed.
- **Razor UI performance**: Avoid heavy allocations in `OnUpdate` on UI components. Use `Tick` with throttling for non-critical updates.
- **Hotloading**: S&box hotloads code changes. Use `[Event.Hotload]` to re-initialize state after code changes. Static state is not preserved across hotloads.
- **Resource paths**: Use forward slashes, relative to the project root. Paths are case-sensitive.
- **`Game.LocalPawn` can be null**: Always null-check `Game.LocalPawn` and `Game.LocalClient` in UI and client code.
- **Component property exposure**: Use `[Property]` to expose fields in the editor, not `public` alone.
- **Scene traces**: Use `Scene.Trace.Ray(...)` for physics raycasting, not the old `Trace.Ray` API.
- **Sound paths**: Sounds must be imported in the sound editor first. The `.vsnd` file is the reference.
- **Entity vs Component**: Prefer `Component` + `GameObject` for new code. The old `Entity`-as-everything model is being phased out.

## Reference

- [S&box Documentation](https://sbox.game/dev/doc)
- [S&box GitHub](https://github.com/Facepunch/sandbox)
- [S&box Asset Workshop](https://sbox.game/dev/assets)
- [S&box Community](https://sbox.game/dev/community)
- [Facepunch Forums](https://forum.facepunch.com/)
