//
//  File.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Station = Resource<StationAttributes, NoRelationship>

public struct StationAttributes: Codable {
    public let artwork: Artwork
    public let durationInMillis: Int?
    public let editorialNotes: EditorialNotes?
    public let episodeNumber: Int?
    public let isLive: Bool
    public let name: String
    public let url: String
}
