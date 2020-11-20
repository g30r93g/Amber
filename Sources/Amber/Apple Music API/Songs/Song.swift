//
//  SongResponse.swift
//
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Song = Resource<SongAttributes, SongRelationships>

public struct SongAttributes: Codable {
    public let albumName: String
    public let artistName: String
    public let artwork: Artwork
    public let composer: String?
    public let contentRating: ContentRating
    public let discNumber: Int?
    public let duration: Int?
    public let editorialNotes: EditorialNotes?
    public let genreNames: [String]
    public let isrc: String?
    public let movementCount: Int?
    public let movementName: String?
    public let movementNumber: Int?
    public let name: String
    public let playParams: PlayParameters?
    public let previews: [Preview]
    public let releaseDate: Date?
    public let trackNumber: Int?
    public let url: String
    public let workName: String?
    
    private enum CodingKeys: String, CodingKey {
        case albumName, artistName, artwork, composer, contentRating, discNumber, editorialNotes, genreNames, isrc, movementCount, movementName, movementNumber, name, playParams, previews, releaseDate, trackNumber, url, workName
        case duration = "durationInMillis"
    }
    
    public init(from decoder: Decoder) throws  {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            self.releaseDate = Date(dateString: releaseDateString, format: "yyyy-MM-dd")
        } else {
            self.releaseDate = nil
        }
        
        self.albumName = try container.decode(String.self, forKey: .albumName)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artwork = try container.decode(Artwork.self, forKey: .artwork)
        self.composer = try container.decodeIfPresent(String.self, forKey: .composer)
        self.contentRating = try container.decodeIfPresent(ContentRating.self, forKey: .contentRating) ?? .clean
        self.discNumber = try container.decodeIfPresent(Int.self, forKey: .discNumber)
        self.duration = try container.decodeIfPresent(Int.self, forKey: .duration)
        self.editorialNotes = try container.decodeIfPresent(EditorialNotes.self, forKey: .editorialNotes)
        self.genreNames = try container.decode([String].self, forKey: .genreNames)
        self.isrc = try container.decodeIfPresent(String.self, forKey: .isrc)
        self.movementCount = try container.decodeIfPresent(Int.self, forKey: .movementCount)
        self.movementName = try container.decodeIfPresent(String.self, forKey: .movementName)
        self.movementNumber = try container.decodeIfPresent(Int.self, forKey: .movementNumber)
        self.name = try container.decode(String.self, forKey: .name)
        self.playParams = try container.decodeIfPresent(PlayParameters.self, forKey: .playParams)
        self.previews = try container.decode([Preview].self, forKey: .previews)
        self.trackNumber = try container.decodeIfPresent(Int.self, forKey: .trackNumber)
        self.url = try container.decode(String.self, forKey: .url)
        self.workName = try container.decodeIfPresent(String.self, forKey: .workName)
    }
}

public struct SongRelationships: Codable {
    public let albums: Relationship<Album>?
    public let artists: Relationship<Artist>?
    public let genres: Relationship<Genre>?
    public let station: Relationship<Station>?
}
