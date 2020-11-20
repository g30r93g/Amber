//
//  Rating.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Rating = Resource<RatingAttributes, NoRelationship>

public struct RatingAttributes: Codable {
    public let value: RatingType
}
