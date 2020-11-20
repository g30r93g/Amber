//
//  LibraryPlaylist.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias LibraryPlaylist = Resource<LibraryPlaylistAttributes, LibraryPlaylistRelationships>

public struct LibraryPlaylistAttributes: Codable {
    public let artwork: Artwork?
    public let description: EditorialNotes?
    public let name: String
    public let playParams: PlayParameters?
    public let canEdit: Bool
}

public struct LibraryPlaylistRelationships: Codable {
    public let tracks: Relationship<LibrarySong>
}

