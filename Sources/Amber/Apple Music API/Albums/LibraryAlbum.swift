//
//  LibraryAlbum.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias LibraryAlbum = Resource<LibraryAlbumAttributes, LibraryAlbumRelationships>

public struct LibraryAlbumAttributes: Codable {
    public let artistName: String
    public let artwork: Artwork
    public let contentRating: ContentRating
    public let name: String
    public let playParams: PlayParameters?
    public let trackCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case artistName, artwork, contentRating, name, playParams, trackCount
    }
    
    public init(from decoder: Decoder) throws  {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.contentRating = try container.decodeIfPresent(ContentRating.self, forKey: .contentRating) ?? .clean
        
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artwork = try container.decode(Artwork.self, forKey: .artwork)
        self.name = try container.decode(String.self, forKey: .name)
        self.playParams = try container.decodeIfPresent(PlayParameters.self, forKey: .playParams)
        self.trackCount = try container.decode(Int.self, forKey: .trackCount)
    }
}

public struct LibraryAlbumRelationships: Codable {
    public let artists: Relationship<Artist>
    public let tracks: Relationship<Song>
}
