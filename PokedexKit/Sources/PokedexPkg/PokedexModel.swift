//
//  File.swift
//  
//
//  Created by Riccardo Cipolleschi on 19/11/21.
//

import Foundation

public struct PokedexModel: Identifiable, Codable {
    public let id: Int
    var name: String
    let numberOfPokemon: Int
    
    // Only to mock the service in the Composition Root
    public init(id: Int, name: String, numberOfPokemon: Int) {
        self.id = id
        self.name = name
        self.numberOfPokemon = numberOfPokemon
    }
}
