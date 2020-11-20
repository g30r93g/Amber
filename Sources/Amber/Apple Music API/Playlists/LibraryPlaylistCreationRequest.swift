//
//  LibraryPlaylistCreationRequest.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias LibraryPlaylistCreationRequest = Resource<LibraryPlaylistCreationRequestAttributes, LibraryPlaylistCreationRequestRelationships>

public struct LibraryPlaylistCreationRequestAttributes: Codable {
    public let description: String?
    public let name: String
}

public struct LibraryPlaylistCreationRequestRelationships: Codable {
    public let tracks: Relationship<LibrarySong>
}
