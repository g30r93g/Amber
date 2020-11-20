//
//  Artist.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Artist = Resource<ArtistAttributes, ArtistRelationships>

public struct ArtistAttributes: Codable {
    public let editorialNotes: EditorialNotes?
    public let genreNames: [String]
    public let name: String
    public let url: String
}

public struct ArtistRelationships: Codable {
    public let albums: Relationship<Album>
    public let genres: Relationship<Genre>?
    public let musicVideos: Relationship<MusicVideo>?
    public let playlists: Relationship<Playlist>?
    public let station: Relationship<Station>?
}
