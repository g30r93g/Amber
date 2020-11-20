//
//  Curator.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Curator = Resource<CuratorAttributes, CuratorRelationships>
public typealias AppleCurator = Curator

public struct CuratorAttributes: Codable {
    public let artwork: Artwork
    public let editorialNotes: EditorialNotes?
    public let name: String
    public let url: String
}

public struct CuratorRelationships: Codable {
    public let playlists: Relationship<Playlist>
}
