//
//  PokemonDetail.swift
//  
//
//  Created by Riccardo Cipolleschi on 19/11/21.
//

import Foundation

public struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let image: URL
    let description: String
    
    // Only to mock the service in the Composition Root
    public init(id: Int, name: String, image: URL, description: String) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
    }
}
