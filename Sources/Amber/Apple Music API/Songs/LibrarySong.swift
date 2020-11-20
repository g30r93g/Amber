//
//  File.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias LibrarySong = Resource<LibrarySongAttributes, LibrarySongRelationships>

public struct LibrarySongAttributes: Codable {
    public let albumName: String
    public let artistName: String
    public let artwork: Artwork
    public let contentRating: ContentRating
    public let discNumber: Int?
    public let duration: Int
    public let name: String
    public let playParams: PlayParameters?
    public let trackNumber: Int
    
    private enum CodingKeys: String, CodingKey {
        case albumName, artistName, artwork, contentRating, discNumber, name, playParams, trackNumber
        case duration = "durationInMillis"
    }
    
    public init(from decoder: Decoder) throws  {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.contentRating = try container.decodeIfPresent(ContentRating.self, forKey: .contentRating) ?? .clean
        
        self.albumName = try container.decode(String.self, forKey: .albumName)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artwork = try container.decode(Artwork.self, forKey: .artwork)
        self.discNumber = try container.decodeIfPresent(Int.self, forKey: .discNumber)
        self.duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        self.name = try container.decode(String.self, forKey: .name)
        self.playParams = try container.decodeIfPresent(PlayParameters.self, forKey: .playParams)
        self.trackNumber = try container.decode(Int.self, forKey: .trackNumber)
    }
}

public struct LibrarySongRelationships: Codable {
    public let albums: Relationship<Album>?
    public let artists: Relationship<Artist>?
}
