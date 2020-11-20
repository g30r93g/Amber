//
//  PlayParameters.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public class PlayParameters: Codable {
    public let id: String
    public let globalId: String?
    public let kind: String
    public let isLibrary: Bool?
    
    public enum CodingKeys: String, CodingKey {
        case id, globalId, kind, isLibrary
    }
}
