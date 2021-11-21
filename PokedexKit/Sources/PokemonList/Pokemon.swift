//
//  File.swift
//  
//
//  Created by Riccardo Cipolleschi on 19/11/21.
//

import Foundation

public struct Pokemon: Identifiable, Codable {
    public let id: Int
    let name: String
    let sprite: URL
    
    // Only to mock the service in the Composition Root
    public init(id: Int, name: String, sprite: URL) {
        self.id = id
        self.name = name
        self.sprite = sprite
    }
}
