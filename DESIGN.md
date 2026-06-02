# C++ ECS Design for PySpice Port

## Architecture Overview

### Core Components

1. **ECS Framework**
   - Entity: Unique ID
   - Component: Data only (POD)
   - System: Logic that operates on entities with specific components
   - World: Manages entities, components, and systems

2. **Signal System**
   - Event bus for decoupled communication
   - `Signal<T...>` class with `connect()` and `fire()` methods
   - Used for scene transitions, gameplay events

3. **Scene System**
   - Abstract `Scene` base class
   - Concrete scenes: `TitleScene`, `MainLoop`
   - Scene switching via signal events

4. **Subsystems**
   - `InputSubsystem`: SFML input handling
   - `GraphicsSubsystem`: Rendering entities
   - `GameplaySubsystem`: Game logic
   - `HudSubsystem`: UI elements
   - `SoundSubsystem`: Audio playback
   - `MusicSubsystem`: Background music

## Component Design

### Core Components
- `Transform`: position, rotation, scale
- `Sprite`: texture, color, shader
- `Collision`: bounding box/sphere
- `Input`: key/mouse bindings
- `GameState`: health, score, level

### Component Requirements
- Plain Old Data (POD)
- Default constructible
- No virtual methods
- Minimal memory overhead

## System Design

### System Requirements
- Operate on entities with specific component combinations
- `update()` method called each frame
- Access world via `World*` parameter

### Core Systems
- `RenderSystem`: Draws entities with Sprite component
- `InputSystem`: Processes input and updates Input components
- `CollisionSystem`: Detects and handles collisions
- `GameplaySystem`: Updates game state
- `HudSystem`: Updates and renders UI

## World Design

### Responsibilities
- Entity creation/destruction
- Component storage/retrieval
- System registration/management
- Frame update loop

### Methods
- `Entity createEntity()`
- `template<typename T> void addComponent(Entity, T)`
- `template<typename T> T* getComponent(Entity)`
- `template<typename T> void addSystem(T*)`
- `void update(float deltaTime)`

## Scene Management

### Scene Lifecycle
1. `load()`: Initialize resources
2. `run()`: Main loop iteration
3. `unload()`: Cleanup resources

### Scene Transitions
- Signals for scene changes
- `onStart()`, `onQuit()`, `onPrevious()` events
- Scene stack for navigation

## SFML Integration

### Window Management
- Single `sf::RenderWindow` managed by application
- Passed to scenes that need rendering

### Resource Management
- `TextureCache`: Loads and manages textures
- `SoundCache`: Loads and manages sounds
- `FontCache`: Loads and manages fonts

## Build System

### Dependencies
- C++26
- SFML (window, graphics, audio, system)
- fmt (formatting)
- Boost (program options)

### Build Commands
```bash
# Configure and build
mkdir -p build && cd build
cmake -S .. -B .
cmake --build .

# Run the application
./build/cppspace

# Clean build
rm -rf build
```

### Build Options
- `-DCMAKE_BUILD_TYPE=Debug` or `Release`
- `-DSFML_DIR=/path/to/sfml` if SFML not in standard location

## Design Constraints

1. **Performance**
   - Minimize component copying
   - Efficient component access
   - Cache-friendly data layouts

2. **Maintainability**
   - Clear separation of concerns
   - Well-documented interfaces
   - Consistent naming conventions

3. **Extensibility**
   - Easy to add new components
   - Simple system composition
   - Flexible resource management
