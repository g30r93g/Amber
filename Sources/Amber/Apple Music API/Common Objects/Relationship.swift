//
//  Relationship.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public struct Relationship<T: Codable>: Codable {
    public let data: [T]?
    public let href: String?
//    public let meta: Meta?
    public let next: String?
}

public struct NoRelationship: Codable { }

public enum Relationships: String, Hashable {
    case songs, albums, artists, playlists
    case musicVideos = "music-videos"
    case tracks, activities, stations
}
