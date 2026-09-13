# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

MyPokedex is an iOS app (SwiftUI + SwiftData, iOS 18.2+ deployment target, Swift 6 language mode) that lists Pokémon loaded from a bundled JSON file and lets the user favorite/unfavorite them into a local SwiftData store.

## Build & test

There is no SPM `Package.swift` — this is an Xcode project (`MyPokedex.xcodeproj`), scheme `MyPokedex`, targets `MyPokedex`, `MyPokedexTests`, `MyPokedexUITests`.

Prefer the `xcode-mcp` skill / `mcp__xcode__*` tools for building, running tests, and rendering previews when available. Equivalent CLI commands:

```sh
# Build
xcodebuild -project MyPokedex.xcodeproj -scheme MyPokedex -destination 'platform=iOS Simulator,name=iPhone 17' build

# Run all tests
xcodebuild -project MyPokedex.xcodeproj -scheme MyPokedex -destination 'platform=iOS Simulator,name=iPhone 17' test

# Run a single test class or method
xcodebuild -project MyPokedex.xcodeproj -scheme MyPokedex -destination 'platform=iOS Simulator,name=iPhone 17' test \
  -only-testing:MyPokedexTests/MyPokedexPokemonViewModelTests
xcodebuild -project MyPokedex.xcodeproj -scheme MyPokedex -destination 'platform=iOS Simulator,name=iPhone 17' test \
  -only-testing:MyPokedexTests/MyPokedexPokemonViewModelTests/testLoadData
```

Tests use XCTest (not Swift Testing) and run against `SwiftDataManager.shared`'s real (in-memory-per-run) model container rather than a mocked persistence layer — they mutate shared state, so don't assume test isolation between them.

## Architecture: three-layer MVVM

The codebase strictly separates three parallel model representations of a Pokémon, converted via explicit mapper extensions — there is no single "Pokemon" type:

- **`PokemonData`** (`Model/PokemonData.swift`) — the SwiftData `@Model` persistence entity. Only favorited Pokémon are ever persisted here.
- **`PokemonDomain`** (`Model/PokemonDomain.swift`) — the `Codable` domain type, also what's decoded directly from `pokemons.json`.
- **`PokemonUi`** (`Model/PokemonUi.swift`) — the view-facing type (adds `imageURL`, currently always `nil` in mappers — image loading is not wired up end to end despite `PokeCell` using `AsyncImage`).

Conversions live in `Pokedex/Mapping/{DataMappers,DomainMappers,UiMappers}.swift`, one file per source layer, each containing extensions that convert *to* the other two layers (e.g. `DataMappers.swift` holds `PokemonData -> PokemonDomain` and `PokemonDomain -> PokemonData`). When adding a field to the Pokémon model, it must be threaded through all three types and their mapper extensions.

Data flow: `RemoteDataSource` (reads bundled `pokemons.json`) and `LocalDataSource` (SwiftData CRUD via `SwiftDataManager.shared`) are both wrapped by `PokemonDataRepository` (`Data/Repository/DataRepository.swift`), which is the single `@MainActor` singleton (`.shared`) injected into view models. Protocols (`PokemonRepositoryProtocol`, `PokemonFavoritedRepositoryProtocol`) split the repository's read-remote vs. favorite-CRUD responsibilities, and view models depend on the narrowest protocol they need — `PokemonDetailViewModel` only needs `PokemonRepositoryProtocol`, `FavoritedPokemonViewModel` only `PokemonFavoritedRepositoryProtocol`, `PokemonViewModel` needs both.

View models (`ViewModel/`) are `ObservableObject` classes constructed directly by views (e.g. `PokemonListView` does `@StateObject var viewmodel = PokemonViewModel(repository: .shared)`) — there is no separate DI container. Tests mock the repository by subclassing `PokemonDataRepository` and overriding `load`/`add`/`delete` (see `MyPokedexTests/*.swift`), not by conforming to the protocols directly.

`FavoritedPokemonsView` additionally uses a live SwiftData `@Query` for its list contents while also holding a `FavoritedPokemonViewModel` for delete actions — favorites are read via `@Query`, not via the view model's own `pokemons` property.

## Concurrency

All three targets build under Swift 6 language mode with zero warnings. There is no background actor anywhere in this codebase — everything that touches SwiftData is pinned to `@MainActor` instead, since all access goes through `SwiftDataManager.shared.modelContext` (the main `ModelContext`) anyway:

- `LocalDataSourceProtocol`, `PokemonRepositoryProtocol`, `PokemonFavoritedRepositoryProtocol`, `LocalDataSource`, and `PokemonDataRepository` are all `@MainActor`.
- `PokemonViewModel` is `@MainActor` at the class level; `FavoritedPokemonViewModel` is not annotated at the class level but isolates its one repository-touching method (`deletePokemonById`) with `@MainActor` instead — don't assume every view model follows the same pattern when adding new methods.
- Avoid `#Predicate` macros over `@Model` properties for anything beyond the simplest key-paths — `@Model` classes aren't `Sendable`, so `#Predicate<PokemonData>{ $0.id == someId }` expands to a non-`Sendable` `KeyPath` capture that warns (Swift 6: errors) under strict concurrency. `LocalDataSource.deletePokemonById` and the test mocks work around this by fetching all rows and filtering/deleting in a loop instead.

Test target gotcha: `XCTestCase`'s synchronous override points (`setUpWithError()`/`tearDownWithError()`) stay `nonisolated` even inside an `@MainActor`-annotated test class — overriding a nonisolated synchronous superclass method can't add isolation. Use the async override points (`override func setUp() async throws` / `override func tearDown() async throws`) instead when the setup needs to touch `@MainActor` state, as both test classes in `MyPokedexTests/` do.
