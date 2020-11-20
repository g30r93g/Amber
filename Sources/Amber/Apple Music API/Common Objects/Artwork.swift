//
//  Artwork.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public class Artwork: Codable {
    public let bgColor: String?
    public let height: Int? = 1000
    public let width: Int? = 1000
    public let textColor1: String?
    public let textColor2: String?
    public let textColor3: String?
    public let textColor4: String?
    public let url: String
}
