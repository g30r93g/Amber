//
//  RequestGenerator.swift
//  
//
//  Created by George Nick Gorzynski on 31/05/2020.
//

import Foundation

internal struct AppleMusicEndpoints {
    
    // Base
    static let base = "api.music.apple.com"
    static let apiVersion = "/v1"
    
    // Test
    static let test = "/test"
    
    // User Individualization and Library
    static let userIndividualization = "/me"
    static let userLibrary = "/me/library"
    static let userRatings = "/me/ratings"
    static let userHistory = "/me/history"
    static let userRecents = "/me/recent"
    static let userRecentlyAdded = "/me/recently-added"
    static let userStorefront = "me/storefront"
    
    // Catalog
    static let catalog = "/catalog/{storefront}"
    static let resource = "/{resource}/{id}/{relationship}"
    
    // Search
    static let search = "/search"
    static let hints = "/hints"
    
    static func catalog(storefront: StorefrontDeterminator.StorefrontDetails?) -> String {
        return self.catalog.replacingOccurrences(of: "{storefront}", with: storefront?.countryCode ?? "UK")
    }
    
    static func resource(resource: Resources, identifier: String? = nil, relationship: Relationships? = nil) -> String {
        var resourceString = self.resource
        
        resourceString = resourceString.replacingOccurrences(of: "{resource}", with: resource.rawValue)
        resourceString = resourceString.replacingOccurrences(of: "{id}", with: identifier ?? "")
        resourceString = resourceString.replacingOccurrences(of: "{relationship}", with: relationship?.rawValue ?? "")
        
        return resourceString
    }
    
    static func individualizationPath(resource: Resources) -> String {
        switch resource {
        case .albums, .artists, .songs, .musicVideos, .playlists, .stations, .libraryRecentlyAdded, .storefront:
            return self.userLibrary
        case .ratings:
            return self.userRatings
        case .libraryHistory, .libraryHeavyRotation:
            return self.userHistory
        case .libraryRecentlyPlayed, .libraryRecentlyPlayedStations:
            return self.userRecents
        default:
            return ""
        }
    }
}

internal class RequestGenerator {
    
    // MARK: Initialisers
    init(_ amber: Amber) {
        self.storefront = amber.storefront
        self.developerToken = amber.developerToken
        self.userToken = amber.userToken
    }
    
    init(storefront: StorefrontDeterminator.StorefrontDetails, developerToken: String, userToken: String? = nil) {
        self.storefront = storefront
        self.developerToken = developerToken
        self.userToken = userToken
    }
    
    // MARK: Properties
    private let storefront: StorefrontDeterminator.StorefrontDetails?
    private let developerToken: String
    private let userToken: String?
    private let cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    private let timeout: TimeInterval = 5
    
    // MARK: URL Generation
    func catalogContentRequest(resource: Resources, types resources: [Resources]? = nil, identifier: String? = nil, identifiers: [String]? = nil, relationship: Relationships? = nil, relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, chart: String? = nil, genre: String? = nil, method: HTTPMethod = .get, body: Data? = nil) -> URLRequest {
        var components = URLComponents()
        
        // URL Path
        components.scheme = "https"
        components.host = AppleMusicEndpoints.base
        components.path = AppleMusicEndpoints.apiVersion + AppleMusicEndpoints.catalog(storefront: self.storefront) + AppleMusicEndpoints.resource(resource: resource, identifier: identifier, relationship: relationship).removeTrailingCharacter(matchng: "/")
        
        // URL Query Params
        components.include(relationships: relationships)
        components.add(identifiers: identifiers)
        
        if let localizationCode = self.storefront?.countryCode {
            components.add(localization: localizationCode)
        }
        
        if let limit = limit {
            components.add(limit: limit)
        }
        
        if let offset = offset {
            components.add(offset: offset)
        }
        
        if resource == .charts {
            components.add(chart: chart)
            components.add(genre: genre)
        }
        
        // Request
        var request = URLRequest(url: components.url!, cachePolicy: self.cachePolicy, timeoutInterval: self.timeout)
        addDeveloperToken(to: &request)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return request
    }
    
    func individualizedContentRequest(resource: Resources, types resources: [Resources]? = nil, identifier: String? = nil, identifiers: [String]? = nil, relationship: Relationships? = nil, relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, chart: String? = nil, genre: String? = nil, method: HTTPMethod = .get, body: Data? = nil) -> URLRequest {
        var components = URLComponents()
        
        // URL Path
        components.scheme = "https"
        components.host = AppleMusicEndpoints.base
        components.path = AppleMusicEndpoints.apiVersion + AppleMusicEndpoints.individualizationPath(resource: resource) + AppleMusicEndpoints.resource(resource: resource, identifier: identifier, relationship: relationship).removeTrailingCharacter(matchng: "/")
        
        // URL Query Params
        components.include(relationships: relationships)
        components.add(identifiers: identifiers)
        
        if let localizationCode = self.storefront?.countryCode {
            components.add(localization: localizationCode)
        }
        
        if let limit = limit {
            components.add(limit: limit)
        }
        
        if let offset = offset {
            components.add(offset: offset)
        }
        
        if resource == .charts {
            components.add(chart: chart)
            components.add(genre: genre)
        }
        
        // Request
        var request = URLRequest(url: components.url!, cachePolicy: self.cachePolicy, timeoutInterval: self.timeout)
        addDeveloperToken(to: &request)
        addUserToken(to: &request)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return request
    }
    
    func individualizedRatingRequest(resource: Resources, identifier: String? = nil, identifiers: [String]? = nil, relationships: [Relationships]? = nil, rating: Rating? = nil, method: HTTPMethod = .get) -> URLRequest {
        var components = URLComponents()
        
        // URL Path
        components.scheme = "https"
        components.host = AppleMusicEndpoints.base
        components.path = AppleMusicEndpoints.apiVersion + AppleMusicEndpoints.individualizationPath(resource: resource) + AppleMusicEndpoints.resource(resource: resource, identifier: identifier).removeTrailingCharacter(matchng: "/")
        
        // URL Query Params
        components.include(relationships: relationships)
        components.add(identifiers: identifiers)
        
        if let localizationCode = self.storefront?.countryCode {
            components.add(localization: localizationCode)
        }
        
        // Request
        var request = URLRequest(url: components.url!, cachePolicy: self.cachePolicy, timeoutInterval: self.timeout)
        addDeveloperToken(to: &request)
        addUserToken(to: &request)
        request.httpMethod = method.rawValue
        request.httpBody = try! JSONEncoder().encode(rating)
        
        return request
    }
    
    func searchRequest(searchTerm: String, limit: Int? = nil, offset: Int? = nil, types resources: [Resources]? = nil) -> URLRequest {
        // Search Term
        let searchTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
        
        // URL Components
        var components = URLComponents()
        
        // URL Path
        components.scheme = "https"
        components.host = AppleMusicEndpoints.base
        components.path = AppleMusicEndpoints.apiVersion + AppleMusicEndpoints.catalog(storefront: self.storefront) + AppleMusicEndpoints.search
        
        // URL Query Params
        components.add(searchTerm: searchTerm)
        components.include(resources: resources)
        
        if let localizationCode = self.storefront?.countryCode {
            components.add(localization: localizationCode)
        }
        
        if let limit = limit {
            components.add(limit: limit)
        }
        
        if let offset = offset {
            components.add(offset: offset)
        }
        
        // Request
        var request = URLRequest(url: components.url!, cachePolicy: self.cachePolicy, timeoutInterval: self.timeout)
        addDeveloperToken(to: &request)
        
        return request
    }
    
    func searchHintRequest(searchTerm: String, limit: Int? = nil, types resources: [Resources]? = nil) -> URLRequest {
        // Search Term
        let searchTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
        
        // URL Components
        var components = URLComponents()
        
        // URL Path
        components.scheme = "https"
        components.host = AppleMusicEndpoints.base
        components.path = AppleMusicEndpoints.apiVersion + AppleMusicEndpoints.catalog(storefront: self.storefront) + AppleMusicEndpoints.search + AppleMusicEndpoints.hints
        
        // URL Query Params
        components.add(searchTerm: searchTerm)
        components.include(resources: resources)
        
        if let localizationCode = self.storefront?.countryCode {
            components.add(localization: localizationCode)
        }
        
        if let limit = limit {
            components.add(limit: limit)
        }
        
        // Request
        var request = URLRequest(url: components.url!, cachePolicy: self.cachePolicy, timeoutInterval: self.timeout)
        addDeveloperToken(to: &request)
        
        return request
    }
    
    func librarySearchRequest(searchTerm: String, limit: Int? = nil, offset: Int? = nil, types resources: [Resources]? = nil) -> URLRequest {
        // Search Term
        let searchTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
        
        // URL Components
        var components = URLComponents()
        
        // URL Path
        components.scheme = "https"
        components.host = AppleMusicEndpoints.base
        components.path = AppleMusicEndpoints.apiVersion + AppleMusicEndpoints.userLibrary + AppleMusicEndpoints.search
        
        // URL Query Params
        components.add(searchTerm: searchTerm)
        components.include(resources: resources)
        
        if let localizationCode = self.storefront?.countryCode {
            components.add(localization: localizationCode)
        }
        
        if let limit = limit {
            components.add(limit: limit)
        }
        
        if let offset = offset {
            components.add(offset: offset)
        }
        
        // Request
        var request = URLRequest(url: components.url!, cachePolicy: self.cachePolicy, timeoutInterval: self.timeout)
        addDeveloperToken(to: &request)
        addUserToken(to: &request)
        
        return request
    }
    
    // MARK: Auth Headers
    private func addUserToken(to request: inout URLRequest) {
        if let token = self.userToken {
            request.setValue(token, forHTTPHeaderField: "Music-User-Token")
        }
    }
    
    private func addDeveloperToken(to request: inout URLRequest) {
        request.setValue("Bearer \(self.developerToken)", forHTTPHeaderField: "Authorization")
    }
    
}

extension URLComponents {
    
    mutating func add(searchTerm: String) {
        var queryItems = self.queryItems ?? []
        
        queryItems.append(URLQueryItem(name: "term", value: searchTerm.replacingOccurrences(of: " ", with: "+")))
        
        self.queryItems = queryItems
    }
    
    mutating func add(identifiers: [String]?) {
        if let ids = identifiers {
            var queryItems = self.queryItems ?? []
            
            queryItems.append(URLQueryItem(name: "ids", value: ids.joined(separator: ",")))
            
            self.queryItems = queryItems
        }
    }
    
    mutating func add(localization: String) {
        var queryItems = self.queryItems ?? []
        
        queryItems.append(URLQueryItem(name: "l", value: localization))
        
        self.queryItems = queryItems
    }
    
    mutating func add(limit: Int) {
        var queryItems = self.queryItems ?? []
        
        queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
        
        self.queryItems = queryItems
    }
    
    mutating func add(offset: Int) {
        var queryItems = self.queryItems ?? []
        
        queryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
        
        self.queryItems = queryItems
    }
    
    mutating func add(chart: String?) {
        if let chart = chart {
            var queryItems = self.queryItems ?? []
            
            queryItems.append(URLQueryItem(name: "chart", value: chart))
            
            self.queryItems = queryItems
        }
    }
    
    mutating func add(genre: String?) {
        if let genre = genre {
            var queryItems = self.queryItems ?? []
            
            queryItems.append(URLQueryItem(name: "genre", value: genre))
            
            self.queryItems = queryItems
        }
    }
        
    mutating func include(relationships: [Relationships]?) {
        if let relationships = relationships {
            var queryItems = self.queryItems ?? []
            
            queryItems.append(URLQueryItem(name: "include", value: relationships.map({$0.rawValue}).joined(separator: ",")))
            
            self.queryItems = queryItems
        }
    }
    
    mutating func include(resources: [Resources]?) {
        if let resources = resources {
            var queryItems = self.queryItems ?? []
            
            queryItems.append(URLQueryItem(name: "types", value: resources.map({$0.rawValue}).joined(separator: ",")))
            
            self.queryItems = queryItems
        }
    }
    
}
