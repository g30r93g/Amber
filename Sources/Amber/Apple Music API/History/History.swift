//
//  History.swift
//  
//
//  Created by George Nick Gorzynski on 18/06/2020.
//

import Foundation

public typealias HeavyRotation = HistoryResource
public typealias RecentlyPlayed = HistoryResource
public typealias RecentlyAdded = HistoryResource

public struct HistoryResource: Codable {
    public let attributes: HistoryAttributes?
    public let href: String?
    public let id: String?
    public let type: String
    
    private enum CodingKeys: String, CodingKey {
        case attributes, href, id, type
    }
    
    public init(from decoder: Decoder) throws  {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "playlists":
            let data = try container.decode(PlaylistAttributes.self, forKey: .attributes)
            self.attributes = .playlist(data)
        case "albums":
            let data = try container.decode(AlbumAttributes.self, forKey: .attributes)
            self.attributes = .album(data)
        case "stations":
            let data = try container.decode(StationAttributes.self, forKey: .attributes)
            self.attributes = .station(data)
        case "library-playlists":
            let data = try container.decode(LibraryPlaylistAttributes.self, forKey: .attributes)
            self.attributes = .libraryPlaylist(data)
        case "library-albums":
            let data = try container.decode(LibraryAlbumAttributes.self, forKey: .attributes)
            self.attributes = .libraryAlbum(data)
        default:
            self.attributes = HistoryAttributes.none
        }
        
        self.type = type
        self.href = try container.decodeIfPresent(String.self, forKey: .href)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.href, forKey: .href)
        try container.encode(self.id, forKey: .id)
        
        switch self.attributes {
        case .album(let data):
            try container.encode(data, forKey: .attributes)
        case .song(let data):
            try container.encode(data, forKey: .attributes)
        case .playlist(let data):
            try container.encode(data, forKey: .attributes)
        case .musicVideo(let data):
            try container.encode(data, forKey: .attributes)
        case .station(let data):
            try container.encode(data, forKey: .attributes)
        case .libraryAlbum(let data):
            try container.encode(data, forKey: .attributes)
        case .librarySong(let data):
            try container.encode(data, forKey: .attributes)
        case .libraryPlaylist(let data):
            try container.encode(data, forKey: .attributes)
        case .libraryMusicVideo(let data):
            try container.encode(data, forKey: .attributes)
        default:
            throw AmberError.unknownDecodeType
        }
    }
    
    public func asAlbum() -> Album? {
        switch self.attributes {
        case .album(let albumAttributes):
            return Album(attributes: albumAttributes, href: self.href, id: self.id, relationships: nil, type: self.type)
        default:
            return nil
        }
    }
    
    public func asSong() -> Song? {
        switch self.attributes {
        case .song(let songAttributes):
            return Song(attributes: songAttributes, href: self.href, id: self.id, relationships: nil, type: self.type)
        default:
            return nil
        }
    }
    
    public func asPlaylist() -> Playlist? {
        switch self.attributes {
        case .playlist(let playlistAttributes):
            return Playlist(attributes: playlistAttributes, href: self.href, id: self.id, relationships: nil, type: self.type)
        default:
            return nil
        }
    }
    
    public func asMusicVideo() -> MusicVideo? {
        switch self.attributes {
        case .musicVideo(let musicVideoAttributes):
            return MusicVideo(attributes: musicVideoAttributes, href: self.href, id: self.id, relationships: nil, type: self.type)
        default:
            return nil
        }
    }
    
    public func asStation() -> Station? {
        switch self.attributes {
        case .station(let stationAttributes):
            return Station(attributes: stationAttributes, href: self.href, id: self.id, relationships: nil, type: self.type)
        default:
            return nil
        }
    }
    
    public func asLibraryAlbum() -> LibraryAlbum? {
        switch self.attributes {
        case .libraryAlbum(let albumAttributes):
            return LibraryAlbum(attributes: albumAttributes, href: self.href, id: self.id, relationships: nil, type: self.type)
        default:
            return nil
        }
    }
    
    public func asLibrarySong() -> LibrarySong? {
        switch self.attributes {
        case .librarySong(let songAttributes):
            return LibrarySong(attributes: songAttributes, href: self.href, id: self.id, relationships: nil, type: self.type)
        default:
            return nil
        }
    }
    
    public func asLibraryPlaylist() -> LibraryPlaylist? {
        switch self.attributes {
        case .libraryPlaylist(let playlistAttributes):
            return LibraryPlaylist(attributes: playlistAttributes, href: self.href, id: self.id, relationships: nil, type: self.type)
        default:
            return nil
        }
    }
    
    public func asLibraryMusicVideo() -> LibraryMusicVideo? {
        switch self.attributes {
        case .libraryMusicVideo(let musicVideoAttributes):
            return LibraryMusicVideo(attributes: musicVideoAttributes, href: self.href, id: self.id, relationships: nil, type: self.type)
        default:
            return nil
        }
    }
}

public enum HistoryAttributes {
    case album(AlbumAttributes)
    case song(SongAttributes)
    case playlist(PlaylistAttributes)
    case musicVideo(MusicVideoAttributes)
    case station(StationAttributes)
    
    case libraryAlbum(LibraryAlbumAttributes)
    case librarySong(LibrarySongAttributes)
    case libraryPlaylist(LibraryPlaylistAttributes)
    case libraryMusicVideo(LibraryMusicVideoAttributes)
    
    case none
}
