//
//  Storefront.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public typealias Storefront = Resource<StorefrontAttributes, NoRelationship>

public struct StorefrontAttributes: Codable {
    public let defaultLanguageTag: String
    public let name: String
    public let supportedLanguageTags: [String]
}
