//
//  LibraryArtist.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias LibraryArtist = Resource<LibraryArtistAttributes, LibraryArtistRelationships>

public struct LibraryArtistAttributes: Codable {
    public let name: String
}

public struct LibraryArtistRelationships: Codable {
    public let albums: Relationship<Album>?
}
