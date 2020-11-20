//
//  LibraryMusicVideo.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias LibraryMusicVideo = Resource<LibraryMusicVideoAttributes, LibraryMusicVideoRelationships>

public struct LibraryMusicVideoAttributes: Codable {
    public let albumName: String
    public let artistName: String
    public let artwork: Artwork
    public let contentRating: ContentRating
    public let duration: Int
    public let name: String
    public let playParams: PlayParameters?
    public let trackNumber: Int?
    
    private enum CodingKeys: String, CodingKey {
        case albumName, artistName, artwork, contentRating, name, playParams, trackNumber
        case duration = "durationInMillis"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.contentRating = try container.decodeIfPresent(ContentRating.self, forKey: .contentRating) ?? .clean
        
        self.albumName = try container.decode(String.self, forKey: .albumName)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artwork = try container.decode(Artwork.self, forKey: .artwork)
        self.duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        self.name = try container.decode(String.self, forKey: .name)
        self.playParams = try container.decodeIfPresent(PlayParameters.self, forKey: .playParams)
        self.trackNumber = try container.decodeIfPresent(Int.self, forKey: .trackNumber)
    }
}

public struct LibraryMusicVideoRelationships: Codable {
    public let albums: Relationship<Album>?
    public let artists: Relationship<Artist>?
}
