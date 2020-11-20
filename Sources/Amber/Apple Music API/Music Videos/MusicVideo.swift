//
//  MusicVideo.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias MusicVideo = Resource<MusicVideoAttributes, MusicVideoRelationships>

public struct MusicVideoAttributes: Codable {
    public let albumName: String?
    public let artistName: String
    public let artwork: Artwork
    public let contentRating: ContentRating
    public let duration: Int
    public let editorialNotes: EditorialNotes?
    public let genreNames: [String]
    public let isrc: String
    public let name: String
    public let playParams: PlayParameters?
    public let previews: [Preview]
    public let releaseDate: Date
    public let trackNumber: Int?
    public let url: String
    public let videoSubType: String?
    public let hasHDR: Bool?
    public let has4K: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case albumName, artistName, artwork, contentRating, editorialNotes, genreNames, isrc, name, playParams, previews, releaseDate, trackNumber, url, videoSubType, hasHDR, has4K
        case duration = "durationInMillis"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.contentRating = try container.decodeIfPresent(ContentRating.self, forKey: .contentRating) ?? .clean
        
        self.albumName = try container.decodeIfPresent(String.self, forKey: .albumName)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artwork = try container.decode(Artwork.self, forKey: .artwork)
        self.duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        self.editorialNotes = try container.decodeIfPresent(EditorialNotes.self, forKey: .editorialNotes)
        self.genreNames = try container.decode([String].self, forKey: .genreNames)
        self.isrc = try container.decode(String.self, forKey: .isrc)
        self.name = try container.decode(String.self, forKey: .name)
        self.playParams = try container.decodeIfPresent(PlayParameters.self, forKey: .playParams)
        self.previews = try container.decode([Preview].self, forKey: .previews)
        self.releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        self.trackNumber = try container.decodeIfPresent(Int.self, forKey: .trackNumber)
        self.url = try container.decode(String.self, forKey: .url)
        self.videoSubType = try container.decodeIfPresent(String.self, forKey: .videoSubType)
        self.hasHDR = try container.decodeIfPresent(Bool.self, forKey: .hasHDR)
        self.has4K = try container.decodeIfPresent(Bool.self, forKey: .has4K)
    }
}

public struct MusicVideoRelationships: Codable {
    public let albums: Relationship<Album>?
    public let artists: Relationship<Artist>
    public let genres: Relationship<Genre>?
}
