//
//  Extensions.swift
//  
//
//  Created by George Nick Gorzynski on 01/06/2020.
//

import Foundation

// MARK: String
extension String {
    
    func removeTrailingCharacter(matchng char: Character) -> String {
        var string = self
        
        if string.isEmpty {
            return string
        }
        
        while true {
            if string.last == char {
                string.remove(at: string.index(before: string.endIndex))
            } else {
                break
            }
        }
        
        return string
    }
    
}

// MARK: Encodable
extension Encodable {
    
    func data() throws -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
}

// MARK: Array
extension Array where Element: Hashable {
    
    func contains(_ elements: [Element]) -> Bool {
        let selfSet = Set(self)
        let comparisonSet = Set(elements)
        
        return !selfSet.intersection(comparisonSet).isEmpty
    }
    
}

extension Array {
    
    mutating func prepend(_ element: Element) {
        self.insert(element, at: 0)
    }
    
}

// MARK: Date
extension Date {
    
    init(dateString: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        self = formatter.date(from: dateString) ?? Date()
    }
    
    init(iso8601: String) {
        self.init(dateString: iso8601, format: "yyyy-MM-dd'T'HH:mm:ss'Z'")
    }
    
}
