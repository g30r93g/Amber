//
//  Activity.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Activity = Resource<ActivityAttributes, ActivityRelationships>

public struct ActivityAttributes: Codable {
    public let artwork: Artwork
    public let editorialNotes: EditorialNotes?
    public let name: String
    public let url: String
}

public struct ActivityRelationships: Codable {
    public let playlists: Relationship<Playlist>
}
