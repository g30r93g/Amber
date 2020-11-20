//
//  Album.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Album = Resource<AlbumAttributes, AlbumRelationships>

public struct AlbumAttributes: Codable {
    public let albumName: String?
    public let artistName: String
    public let artwork: Artwork?
    public let contentRating: ContentRating
    public let copyright: String?
    public let editorialNotes: EditorialNotes?
    public let genreNames: [String]
    public let isComplete: Bool
    public let isSingle: Bool
    public let name: String
    public let playParams: PlayParameters?
    public let recordLabel: String
    public let releaseDate: Date
    public let trackCount: Int
    public let url: String
    public let isMasteredForItunes: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case albumName, artistName, artwork, contentRating, copyright, editorialNotes, genreNames, isComplete, isSingle, name, playParams, recordLabel, releaseDate, trackCount, url, isMasteredForItunes
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
        self.releaseDate = Date(dateString: releaseDateString, format: "yyyy-MM-dd")
        
        self.contentRating = try container.decodeIfPresent(ContentRating.self, forKey: .contentRating) ?? .clean
        
        self.albumName = try container.decodeIfPresent(String.self, forKey: .albumName)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artwork = try container.decode(Artwork.self, forKey: .artwork)
        self.copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
        self.editorialNotes = try container.decodeIfPresent(EditorialNotes.self, forKey: .editorialNotes)
        self.genreNames = try container.decode([String].self, forKey: .genreNames)
        self.isComplete = try container.decode(Bool.self, forKey: .isComplete)
        self.isSingle = try container.decode(Bool.self, forKey: .isSingle)
        self.name = try container.decode(String.self, forKey: .name)
        self.playParams = try container.decodeIfPresent(PlayParameters.self, forKey: .playParams)
        self.recordLabel = try container.decode(String.self, forKey: .recordLabel)
        self.trackCount = try container.decode(Int.self, forKey: .trackCount)
        self.url = try container.decode(String.self, forKey: .url)
        self.isMasteredForItunes = try container.decodeIfPresent(Bool.self, forKey: .isMasteredForItunes)
    }
}

public struct AlbumRelationships: Codable {
    public let artists: Relationship<Artist>?
    public let genres: Relationship<Genre>?
    public let tracks: Relationship<Song>?
}
