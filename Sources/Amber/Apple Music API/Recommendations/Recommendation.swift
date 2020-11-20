//
//  Recommendation.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Recommendation = Resource<RecommendationAttributes, RecommendationRelationships>

public struct RecommendationAttributes: Codable {
    public let isGroupRecommendation: Bool
    public let nextUpdateDate: Date
    public let reason: String
    public let resourceTypes: [String]
    public let title: String
}

// HELPME: What is ContentRelationship or GroupRecommendations??
public struct RecommendationRelationships: Codable {
//    public let contents: Relationship<ContentRelationship>
//    public let recommendations: Relationship<GroupRecommendations>
}
