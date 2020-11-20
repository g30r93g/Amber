//
//  Genre.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Genre = Resource<GenreAttributes, NoRelationship>

public struct GenreAttributes: Codable {
    public let name: String
}
