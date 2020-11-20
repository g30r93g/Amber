//
//  RatingRequest.swift
//  
//
//  Created by George Nick Gorzynski on 07/06/2020.
//

import Foundation

public typealias RatingRequest = Resource<RatingRequestAttributes, NoRelationship>

public struct RatingRequestAttributes: Codable {
    public let value: RatingType
}
