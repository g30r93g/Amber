//
//  ContentRating.swift
//  
//
//  Created by George Nick Gorzynski on 22/06/2020.
//

import Foundation

public enum ContentRating: String, Codable {
    case clean, explicit
    
    public init(from decoder: Decoder) throws {
        self = try ContentRating(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .clean
    }
}
