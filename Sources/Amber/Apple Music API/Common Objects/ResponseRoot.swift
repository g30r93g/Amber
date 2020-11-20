//
//  ResponseRoot.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public struct ResponseRoot<T: Codable>: Codable {
    public let data: [T]?
    public let errors: [AMError]?
    public let href: String?
//    public let meta: ResponseRoot.Meta?
    public let next: String?
    public let results: T?
}
