---
name: "Unreal Engine Development"
description: "Build games and applications with Unreal Engine 5 — C++ gameplay framework, Blueprints, UProperties, UFunctions, Actors, Components, Enhanced Input, Gameplay Abilities, Niagara, behavior trees, and performance optimization."
---

# Unreal Engine Development

> Build games and applications with Unreal Engine 5 — C++ gameplay framework, Blueprints, UProperties, UFunctions, Actors, Components, Enhanced Input, Gameplay Abilities, Niagara, behavior trees, and performance optimization.

## When to use

Use this skill when working with Unreal Engine: writing C++ gameplay classes, creating Blueprints, setting up Actors and Components, implementing input handling, designing AI behavior trees, building UI with UMG, working with Gameplay Abilities, creating Niagara effects, or optimizing performance.

## Core architecture

- **Unreal Header Tool (UHT)** — Macros like `UCLASS()`, `UPROPERTY()`, `UFUNCTION()` generate reflection data. The UHT runs during compilation and produces generated code.
- **Garbage-collected UObject hierarchy** — All UObject-derived classes are GC-managed. `AActor`, `UActorComponent`, `UUserWidget` all inherit from `UObject`.
- **Actor/Component model** — `AActor` is the base for everything that can be placed in a level. `UActorComponent` adds reusable functionality to Actors. `USceneComponent` provides transforms.
- **Gameplay Framework** — Built-in roles: `AGameModeBase` (rules), `APlayerController` (input), `APawn`/`ACharacter` (representation), `APlayerState` (persistent player data), `AGameStateBase` (shared state).
- **Blueprint + C++** — C++ defines base classes and performance-critical logic. Blueprints extend and wire up gameplay. The convention is "C++ for structure, Blueprint for iteration."
- **World-centric** — Everything runs in a `UWorld` instance. Worlds contain levels, manage actors, handle ticking, and replicate state.

## UCLASS, UPROPERTY, UFUNCTION macros

### UCLASS

```cpp
UCLASS(BlueprintType, Blueprintable, Abstract, NotPlaceable)
class MYGAME_API AMyActor : public AActor
{
    GENERATED_BODY()
};

// Common specifiers:
// BlueprintType           — Exposed as variable type in Blueprints
// Blueprintable           — Can be extended in Blueprints
// Abstract                — Can't be instantiated directly
// NotPlaceable            — Can't be placed in level
// HideDropdown            — Hidden from actor placement list
// Within=SomeOtherClass   — Must be created within another class
// Config=Game             — Serialize to config file
```

### UPROPERTY

```cpp
UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Movement")
float MoveSpeed = 600.0f;

// Common specifiers:
// EditAnywhere            — Editable in all instances and archetypes
// EditDefaultsOnly        — Editable only on the CDO (class default)
// EditInstanceOnly        — Editable only on placed instances
// VisibleAnywhere         — Read-only in details panel
// BlueprintReadWrite      — Read/write from Blueprints
// BlueprintReadOnly       — Read-only from Blueprints
// Category="Name"         — Organizes in details panel
// Meta = (MakeEditWidget) — Visual editing in viewport
// Meta = (ClampMin = 0, ClampMax = 100) — Value clamping
// Replicated              — Replicated across network
// Transient               — Not serialized
// SaveGame                — Included in save games
// Instanced               — Creates a subobject instance
```

### UFUNCTION

```cpp
UFUNCTION(BlueprintCallable, Category = "Gameplay")
void FireWeapon();

UFUNCTION(BlueprintImplementableEvent, Category = "Events")
void OnHit(FVector ImpactPoint);
// BlueprintImplementableEvent — No C++ body, implemented in BP

UFUNCTION(BlueprintNativeEvent, Category = "Events")
void OnDeath();
// BlueprintNativeEvent — C++ default body with _Implementation suffix
void OnDeath_Implementation();

UFUNCTION(BlueprintPure, Category = "Math")
float GetHealthPercent() const;

UFUNCTION(Server, Reliable, WithValidation)
void Server_FireWeapon();
// Server — Runs only on server
// Client — Runs only on owning client
// NetMulticast — Runs on all connections
// Reliable — Guaranteed delivery
// Unreliable — Best-effort (for frequent updates)
// WithValidation — Adds Server_Validate function for anti-cheat

UFUNCTION(meta = (WorldContext = "WorldContextObject"))
static void SpawnMyActor(UObject* WorldContextObject);
```

### USTRUCT

```cpp
USTRUCT(BlueprintType)
struct FInventoryItem
{
    GENERATED_BODY()

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    FName ItemID;

    UPROPERTY(EditAnywhere, BlueprintReadWrite)
    int32 Quantity = 0;
};
```

### UINTERFACE

```cpp
UINTERFACE(BlueprintType, MinimalAPI)
class UInteractable : public UInterface
{
    GENERATED_BODY()
};

class IInteractable
{
    GENERATED_BODY()

public:
    UFUNCTION(BlueprintNativeEvent, BlueprintCallable, Category = "Interaction")
    void OnInteract(AActor* Instigator);
};
```

## Actors and Components

### AActor lifecycle

```cpp
AActor::BeginPlay()    // Called when the game starts or actor is spawned
AActor::Tick(float DeltaTime) // Every frame if Tick is enabled
AActor::EndPlay(const EEndPlayReason::Type EndPlayReason)  // When actor is destroyed

// Lifecycle order:
// PreInitializeComponents → InitializeComponents → PostInitializeComponents
// → BeginPlay → Tick → EndPlay → Destroyed
```

### Custom ActorComponent

```cpp
UCLASS(ClassGroup = (Custom), meta = (BlueprintSpawnableComponent))
class UHealthComponent : public UActorComponent
{
    GENERATED_BODY()

public:
    UHealthComponent();

    UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Health", Replicated)
    float MaxHealth = 100.0f;

    UPROPERTY(BlueprintReadOnly, ReplicatedUsing = OnRep_CurrentHealth)
    float CurrentHealth;

    UFUNCTION(BlueprintCallable, Category = "Health")
    void ApplyDamage(float Damage, AActor* DamageInstigator);

protected:
    virtual void BeginPlay() override;

    UFUNCTION()
    void OnRep_CurrentHealth();

private:
    void HandleDeath(AActor* DamageInstigator);
};
```

### Spawning actors

```cpp
// Spawn in level
FActorSpawnParameters SpawnParams;
SpawnParams.SpawnCollisionHandlingOverride = ESpawnActorCollisionHandlingMethod::AdjustIfPossibleButAlwaysSpawn;
SpawnParams.Instigator = this;

AMyActor* Actor = GetWorld()->SpawnActor<AMyActor>(ActorClass, Location, Rotation, SpawnParams);

// Destroy
Actor->Destroy();
```

## Gameplay framework

| Class | Role |
|-------|------|
| `AGameModeBase` | Game rules, spawning, game state. One per world. |
| `AGameStateBase` | Replicated state about the game (score, match time). |
| `APlayerController` | Input handling, HUD management, viewport control. |
| `APlayerState` | Replicated per-player data (name, score, team). |
| `APawn` | Physical representation, possesses by PlayerController or AI. |
| `ACharacter` | Pawn with movement component, capsule collision, mesh. |
| `APlayerCameraManager` | Camera view logic. |
| `AHUD` | HUD rendering (legacy; use UMG widgets instead). |

### Common flow

```cpp
// In GameMode class
APlayerController* AGameModeBase::Login(...);        // Player joins
void AGameModeBase::PostLogin(APlayerController*);    // Called after login
void AGameModeBase::HandleStartingNewPlayer(APlayerController*); // After PostLogin
APawn* AGameModeBase::SpawnDefaultPawnFor(APlayerController*, FVector, FRotator);
AActor* AGameModeBase::FindPlayerStart(APlayerController*); // Spawn location
```

## Movement and input

### Character Movement Component

```cpp
// Basic setup in character constructor
UCharacterMovementComponent* Movement = GetCharacterMovement();
Movement->MaxWalkSpeed = 600.0f;
Movement->JumpZVelocity = 420.0f;
Movement->AirControl = 0.35f;
Movement->GravityScale = 1.75f;
Movement->SetWalkableFloorAngle(45.0f);
```

### Enhanced Input (UE5+)

```cpp
// In APlayerController subclass
#include "EnhancedInputComponent.h"
#include "EnhancedInputSubsystems.h"
#include "InputActionValue.h"

UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = Input)
UInputMappingContext* DefaultMappingContext;

UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = Input)
UInputAction* MoveAction;

UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = Input)
UInputAction* LookAction;

UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = Input)
UInputAction* JumpAction;

virtual void SetupInputComponent() override
{
    Super::SetupInputComponent();

    if (UEnhancedInputComponent* EnhancedInput = Cast<UEnhancedInputComponent>(InputComponent))
    {
        EnhancedInput->BindAction(MoveAction, ETriggerEvent::Triggered, this, &APlayerController::Move);
        EnhancedInput->BindAction(LookAction, ETriggerEvent::Triggered, this, &APlayerController::Look);
        EnhancedInput->BindAction(JumpAction, ETriggerEvent::Started, this, &APlayerController::Jump);
    }
}

void Move(const FInputActionValue& Value)
{
    FVector2D MovementVector = Value.Get<FVector2D>();
    if (APawn* ControlledPawn = GetPawn())
    {
        ControlledPawn->AddMovementInput(ControlledPawn->GetActorForwardVector(), MovementVector.Y);
        ControlledPawn->AddMovementInput(ControlledPawn->GetActorRightVector(), MovementVector.X);
    }
}

void Look(const FInputActionValue& Value)
{
    FVector2D LookAxisVector = Value.Get<FVector2D>();
    if (APawn* ControlledPawn = GetPawn())
    {
        ControlledPawn->AddControllerYawInput(LookAxisVector.X);
        ControlledPawn->AddControllerPitchInput(LookAxisVector.Y);
    }
}
```

### Legacy input (UE4-style)

```cpp
// In SetupInputComponent
InputComponent->BindAxis("MoveForward", this, &AMyCharacter::MoveForward);
InputComponent->BindAxis("MoveRight", this, &AMyCharacter::MoveRight);
InputComponent->BindAction("Jump", IE_Pressed, this, &ACharacter::Jump);
```

## Blueprint communication

### From C++ to Blueprint

```cpp
// Call Blueprint event from C++
UFUNCTION(BlueprintImplementableEvent, Category = "Effects")
void PlayHitEffect(FVector HitLocation);

// Call with C++ default
UFUNCTION(BlueprintNativeEvent)
void OnHealthChanged(float OldHealth, float NewHealth);
void OnHealthChanged_Implementation(float OldHealth, float NewHealth);
```

### From Blueprint to C++

```cpp
UFUNCTION(BlueprintCallable, Category = "Gameplay")
void FireWeapon();  // Callable from BP

UFUNCTION(BlueprintPure, Category = "Math")
bool IsAlive() const;  // Pure = no execution pin
```

### Blueprint casts

```cpp
// C++ safe cast
AActor* OtherActor = OverlapResult.GetActor();
if (AMyCharacter* Character = Cast<AMyCharacter>(OtherActor))
{
    Character->TakeDamage(Damage);
}

// BP cast node: Cast To MyCharacter
```

## AI & Behavior Trees

### Blackboard keys

```cpp
UBlackboardData* BlackboardAsset;
// Define keys: TargetActor, MoveToLocation, bHasSeenEnemy, State
```

### Custom BT task (C++)

```cpp
UCLASS()
class UBTTask_FindEnemy : public UBTTaskNode
{
    GENERATED_BODY()

    virtual EBTNodeResult::Type ExecuteTask(UBehaviorTreeComponent& OwnerComp, uint8* NodeMemory) override
    {
        if (AAIController* AIController = OwnerComp.GetAIOwner())
        {
            if (APawn* Pawn = AIController->GetPawn())
            {
                AActor* Enemy = FindNearestEnemy(Pawn);
                OwnerComp.GetBlackboardComponent()->SetValueAsObject("TargetActor", Enemy);
                return Enemy ? EBTNodeResult::Succeeded : EBTNodeResult::Failed;
            }
        }
        return EBTNodeResult::Failed;
    }
};
```

### Custom BT decorator

```cpp
UCLASS()
class UBTDecorator_HasLineOfSight : public UBTDecorator
{
    GENERATED_BODY()

    virtual bool CalculateRawConditionValue(UBehaviorTreeComponent& OwnerComp, uint8* NodeMemory) const override
    {
        if (AAIController* AIC = OwnerComp.GetAIOwner())
        {
            AActor* Target = Cast<AActor>(OwnerComp.GetBlackboardComponent()->GetValueAsObject("TargetActor"));
            return Target && AIC->LineOfSightTo(Target);
        }
        return false;
    }
};
```

### AI Controller

```cpp
class AMyAIController : public AAIController
{
    UPROPERTY(EditAnywhere, Category = "AI")
    UBehaviorTree* BehaviorTree;

    virtual void OnPossess(APawn* InPawn) override
    {
        Super::OnPossess(InPawn);
        RunBehaviorTree(BehaviorTree);
    }
};
```

## UMG UI

### Creating widgets in C++

```cpp
// Create widget
UUserWidget* Widget = CreateWidget<UUserWidget>(GetWorld(), WidgetClass);

// Add to viewport
Widget->AddToViewport(ZOrder);

// Add to player screen
APlayerController* PC = GetWorld()->GetFirstPlayerController();
Widget->AddToPlayerScreen(ZOrder);

// Remove
Widget->RemoveFromParent();
```

### Common UMG classes

```cpp
UImage*     Icon;       // SetBrushFromTexture
UTextBlock* Label;      // SetText
UButton*    Button;     // OnClicked dynamic delegate
UCanvasPanel* Canvas;   // Root panel for absolute positioning
UHorizontalBox* HBox;   // Horizontal layout
UVerticalBox* VBox;     // Vertical layout
UOverlay*   Overlay;    // Stacked layout
UScrollBox* Scroller;   // Scrollable container
```

### Accessing C++ data from UMG

```cpp
// GetOwningPlayerPawn() in BP to reach character
// Bind widgets in C++ via BindWidget:
UPROPERTY(meta = (BindWidget))
UTextBlock* HealthText;

// Or BindWidgetOptional for optional widgets
UPROPERTY(meta = (BindWidgetOptional))
UImage* BackgroundImage;
```

## Networking & replication

### Replication setup

```cpp
// In .h
UPROPERTY(Replicated)
float Health;

UPROPERTY(ReplicatedUsing = OnRep_Ammo)
int32 Ammo;

UFUNCTION()
void OnRep_Ammo();

// In .cpp
void AMyActor::GetLifetimeReplicatedProps(TArray<FLifetimeProperty>& OutLifetimeProps) const
{
    Super::GetLifetimeReplicatedProps(OutLifetimeProps);
    DOREPLIFETIME(AMyActor, Health);
    DOREPLIFETIME_CONDITION(AMyActor, Ammo, COND_OwnerOnly);
}
```

### RPC modes

| Specifier | Runs On |
|-----------|---------|
| `Client` | Owning client only |
| `Server` | Server only |
| `NetMulticast` | Everyone (server + all clients) |
| ` unreliable` | Best-effort (use for frequent, non-critical updates) |
| ` Reliable` | Guaranteed delivery (use for gameplay-critical events) |

## Niagara

### From C++

```cpp
UNiagaraComponent* NiagaraComp = UNiagaraFunctionLibrary::SpawnSystemAtLocation(
    GetWorld(),
    NiagaraSystem,
    Location,
    Rotation
);

// Or attach to a component
UNiagaraComponent* NiagaraComp = UNiagaraFunctionLibrary::SpawnSystemAttached(
    NiagaraSystem,
    RootComponent,
    NAME_None,
    Location,
    Rotation,
    EAttachLocation::KeepWorldPosition,
    true  // Auto destroy
);

// Set parameters
NiagaraComp->SetVariableFloat("SpawnRate", 100.0f);
NiagaraComp->SetVariableVec3("Color", FVector(1, 0, 0));
NiagaraComp->SetVariableObject("Mesh", StaticMesh);
```

## Gameplay Ability System (GAS)

### Core classes

| Class | Purpose |
|-------|---------|
| `UGameplayAbility` | An action a character can do (cast, attack, block) |
| `UAttributeSet` | Collection of gameplay attributes (health, mana, strength) |
| `UGameplayEffect` | Temporary or permanent modifier to attributes |
| `UGameplayAbilitySystemComponent` (ASC) | Central component managing abilities and effects |
| `UGameplayTask` | Async tasks within abilities |

### Minimal setup

```cpp
// 1. Add ASC to character
UPROPERTY(VisibleAnywhere, BlueprintReadOnly)
UAbilitySystemComponent* AbilitySystemComponent;

// 2. Give ability at start
void AMyCharacter::BeginPlay()
{
    Super::BeginPlay();
    if (AbilitySystemComponent)
    {
        AbilitySystemComponent->GiveAbility(FGameplayAbilitySpec(AbilityClass, Level, InputID));
    }
}

// 3. Activate ability
AbilitySystemComponent->TryActivateAbilityByClass(AbilityClass);
```

## Performance optimization

### General rules
- Use `FActorPool` for frequently spawned/destroyed actors
- Profile with `Unreal Insights` and the console profiler (`stat unit`, `stat fps`, `stat game`)
- Use `SimpleConstructionScript` for static meshes — avoid over-nesting scene components
- Prefer `TArray` with `Add`/`Emplace` over `TSet`/`TMap` for iteration-heavy paths
- Use `ParallelFor` for data-parallel CPU work
- Avoid `GetAllActorsOfClass` in hot paths — maintain a registry

### Asset and memory

- Use `Soft Object Ptrs` (`TSoftObjectPtr`) for references that shouldn't load synchronously
- Load async with `FStreamableManager` or `AsyncLoadPrimaryAsset`
- Use `Level Streaming` for open worlds
- Enable `Texture Streaming` and `Virtual Texturing`
- Use `Nanite` for high-poly static meshes (UE5+)
- Use `World Partition` for large worlds

### Blueprint performance

- `CAST` nodes are expensive. Prefer `Get Default Object` where possible.
- Avoid `Tick` in Blueprints entirely — use timers, event-driven patterns
- Use `Construction Script` sparingly — it runs on every parameter change
- Prefer `For Each Loop` with struct arrays rather than individual variable access

## Console commands & debug

```cpp
// Custom console command
FAutoConsoleCommand Cmd = FAutoConsoleCommand(
    TEXT("mycommand"),
    TEXT("Does something useful"),
    FConsoleCommandDelegate::CreateLambda([]()
    {
        // ...
    })
);

// Visual helpers
DrawDebugSphere(GetWorld(), Location, Radius, Segments, Color, false, Duration);
DrawDebugLine(GetWorld(), Start, End, Color, false, Duration);
DrawDebugBox(GetWorld(), Center, Extent, Rotation, Color, false, Duration);
DrawDebugString(GetWorld(), Location, TEXT("Hello"), nullptr, Color, Duration);
```

## Project organization

```
Source/
└── MyGame/
    ├── MyGame.h
    ├── MyGame.cpp
    ├── Characters/        # Pawn, Character subclasses
    │   ├── MyCharacter.h/cpp
    │   └── MyAnimInstance.h/cpp
    ├── Components/        # ActorComponents
    │   ├── HealthComponent.h/cpp
    │   └── InventoryComponent.h/cpp
    ├── GameModes/         # GameMode, GameState, PlayerState
    │   ├── MyGameMode.h/cpp
    │   └── MyGameState.h/cpp
    ├── Player/            # PlayerController, PlayerState
    │   └── MyPlayerController.h/cpp
    ├── Abilities/         # GAS: abilities, effects, attributes
    │   ├── MyAttributeSet.h/cpp
    │   └── GA_Fire.h/cpp
    ├── AI/                # Behavior Tree tasks, decorators, services
    │   └── BTTask_FindEnemy.h/cpp
    ├── UI/                # Widgets, HUD classes
    │   └── MyHUDWidget.h/cpp
    ├── Items/             # Pickups, weapons
    └── Data/              # DataAssets, Structs, enums

Content/
├── Blueprints/           # Blueprint extensions of C++ classes
├── Maps/                 # Level files
├── Meshes/               # Static/Skeletal meshes
├── Textures/             # Textures and materials
├── Audio/                # Sound waves, cues, mixers
├── Animation/            # Animation blueprints, montages
├── UI/                   # UMG widgets, fonts, images
└── Niagara/              # Niagara systems and emitters
```

## Pitfalls & gotchas

- **`UPROPERTY()` is required for GC**: Any UObject pointer without `UPROPERTY` can be garbage collected without warning.
- **`TArray` vs raw arrays**: Always use `TArray` for dynamic arrays. Raw arrays break reflection and GC scanning.
- **`FTimerHandle` persistence**: Timers persist even if the owning actor is destroyed (unless using `FTimerManager::ClearAllTimersForObject`).
- **`GetWorld()` can return null**: In construction scripts, `BeginPlay` hasn't been called yet, and `GetWorld()` may be `nullptr`.
- **`BeginPlay` order across actors**: Not guaranteed. Use `AActor::PostInitializeComponents` or event-driven design if ordering matters.
- **`Replicated` properties only sync from server**: Clients cannot replicate to server — use Server RPCs.
- **Blueprint nativization was removed**: UE5 removed nativization. Profile with `stat game` instead.
- **`Cast` returns nullptr on failure**: Always check. Use `CastChecked` only when failure is a crash-worth bug.
- **`FMemory::Malloc` vs `new`**: Prefer UE's allocators. Use `MakeShared`, `MakeUnique`, `NewObject`, `CreateDefaultSubobject` for UE-managed types.
- **`CreateDefaultSubobject` must be called in constructor**: Cannot create default subobjects outside of the constructor.
- **`FText` vs `FString`**: `FText` is localized. Use `FText` for all user-facing strings. Use `FString` for internal processing.
- **`Switch`/`Has Authority` cross-play**: Always check authority before modifying replicated state. Only the server can authoritatively modify replicated properties.
- **Enhanced Input vs Legacy**: Use Enhanced Input for new UE5 projects. Legacy input (`BindAxis`, `BindAction`) is deprecated but not removed.
- **`World Partition` requires streaming**: Dynamic levels need `World Partition` setup. Not all projects need it.
- **`UObject` outside UWorld**: Standalone UObjects won't tick or replicate. Use `AActor` or add to an `FTicker`.

## Reference

- [Unreal Engine Documentation](https://dev.epicgames.com/documentation/en-us/unreal-engine/unreal-engine-5-4-documentation)
- [Unreal Engine API Reference](https://dev.epicgames.com/documentation/en-us/unreal-engine/API)
- [Unreal Engine C++ Programming Guide](https://dev.epicgames.com/documentation/en-us/unreal-engine/programming-with-cpp-in-unreal-engine)
- [Unreal Engine Forums](https://forums.unrealengine.com/)
- [Unreal Engine Issue Tracker](https://issues.unrealengine.com/)
- [Unreal Engine Learning Library](https://dev.epicgames.com/community/unreal-engine/learning)
