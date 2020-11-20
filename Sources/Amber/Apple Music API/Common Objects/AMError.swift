//
//  File.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public struct AMError: Error, Codable {
    public let code: String
    public let detail: String?
    public let id: String
//    public let source: Source?
    public let status: String
    public let title: String
    
    public struct Source {
        public let parameter: String?
//        public let pointer: JSONPointer?
    }
}
