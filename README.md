# Amber

An Apple Music API client written in Swift.

## Installation

You can install this via SPM by adding the following to your project's Package.swift file:

```swift
dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/g30r93g/Amber", from: .branch("master")),
],
```

If you wish to install this manually, use `git clone https://github.com/g30r93g/Amber.git` and copy the `Sources` folder into your project.

## Setup

First, you'll need to generate a developer key at [developer.apple.com](https://developer.apple.com/account) for MusicKit. A guide on how to do this is available [here](https://developer.apple.com/documentation/applemusicapi/getting_keys_and_creating_tokens) on the Apple Music API reference.

Once obtained, you'll need to convert the .p8 file with the developer key to a JWT, which is your developer token. There are several 3rd party tools that you can run from Terminal to obtain a JWT. I'd personally recommend [apple-music-token-node](https://github.com/sheminusminus/apple-music-token-node) by [Emily Kolar](https://github.com/sheminusminus).

The token from this can then be used to test Amber. For production, it will need to be generated on the fly, as issued JWT's have a limited lifespan.

## Usage

This is written directly against the Apple Music API. Please check the [Apple Music API documentation](developer.apple.com/documentation/applemusicapi) for more details.

To play an item, a player instance is available within the Amber library.
```swift
import Amber

// If you leave userToken and storefront, they will automatically be determined.
let amber = Amber(developerToken: "---", userToken: "---", storefront: .uk)

amber.player.play("\(trackIdentifier)")
```

## Notes

The following methods are partially implemented:

### Amber.swift
```swift
public func updateStorefront(to countryCode: String? = nil)
```

The following methods are not implemented and will complete with error `AmberError.notImplemented`:

### Amber.swift
```swift
public func getAllLibraryAlbums(include relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[LibraryAlbum], AmberError>) -> Void)

public func getAllLibraryArtists(include relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[LibraryArtist], AmberError>) -> Void)

public func getAllLibrarySongs(include relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[LibrarySong], AmberError>) -> Void)

public func getAllLibraryMusicVideos(include relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[LibraryMusicVideo], AmberError>) -> Void)

public func getAllLibraryPlaylists(include relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[LibraryPlaylist], AmberError>) -> Void)

public func addTracksToLibraryPlaylist(identifier: String, playlistTracksRequest: LibraryPlaylistTracksRequest, completion: @escaping(Result<Void?, AmberError>) -> Void)

public func addResourceToLibrary(identifiers: [(Resources, String)], completion: @escaping(Result<Void, AmberError>) -> Void)
```

PRs are very welcome and any issues, please [open an issue](https://github.com/g30r93g/Amber/issues/new).

## Attribution Message

I have taken inspiration from [Cider](https://github.com/scottrhoyt/Cider) by Scott Hoyt to write this Apple Music API client.
