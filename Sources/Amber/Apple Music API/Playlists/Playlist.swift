//
//  Playlist.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Playlist = Resource<PlaylistAttributes, PlaylistRelationships>

public struct PlaylistAttributes: Codable {
    public let artwork: Artwork?
    public let curatorName: String?
    public let description: EditorialNotes?
    public let lastModifiedDate: Date?
    public let name: String
    public let playParams: PlayParameters?
    public let playlistType: String
    public let url: String
    
    public enum CodingKeys: String, CodingKey {
        case artwork, curatorName, description, lastModifiedDate, name, playParams, playlistType, url
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let lastModifiedDateString = try container.decodeIfPresent(String.self, forKey: .lastModifiedDate) {
            self.lastModifiedDate = Date(iso8601: lastModifiedDateString)
        } else {
            self.lastModifiedDate = nil
        }
        
        self.artwork = try container.decodeIfPresent(Artwork.self, forKey: .artwork)
        self.curatorName = try container.decodeIfPresent(String.self, forKey: .curatorName)
        self.description = try container.decodeIfPresent(EditorialNotes.self, forKey: .description)
        self.name = try container.decode(String.self, forKey: .name)
        self.playParams = try container.decodeIfPresent(PlayParameters.self, forKey: .playParams)
        self.playlistType = try container.decode(String.self, forKey: .playlistType)
        self.url = try container.decode(String.self, forKey: .url)
    }
}

public struct PlaylistRelationships: Codable {
    public let curator: Relationship<Curator>?
    public let tracks: Relationship<Song>
}
