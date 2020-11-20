//
//  Resource.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public struct Resource<Attribute: Codable, Relationship: Codable>: Codable {
    public let attributes: Attribute?
    public let href: String?
    public let id: String?
    public let relationships: Relationship?
    public let type: String
//    public let meta: Meta?
}

public struct EmptyResource: Codable { }

public enum Resources: String {
    // Catalog Resources
    case albums, artists, playlists, songs, stations, activities, charts, genres, curators, ratings
    case musicVideos = "music-videos"
    case appleCurators = "apple-curators"
    
    // Library Resources
    case libraryAlbums = "library-albums"
    case libraryArtists = "library-artists"
    case libraryMusicVideos = "library-music-videos"
    case libraryPlaylists = "library-playlists"
    case librarySongs = "library-songs"
    case libraryRecommendations = "recommendations"
    case libraryHistory = "history"
    case libraryRecentlyPlayed = "played"
    case libraryRecentlyPlayedStations = "radio-stations"
    case libraryRecentlyAdded = "recently-added"
    case libraryHeavyRotation = "heavy-rotation"
    
    // Other Resources
    case search
    case storefront
    case none
}
