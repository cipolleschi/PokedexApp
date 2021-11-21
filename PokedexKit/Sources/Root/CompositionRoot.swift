//
//  CompositionRoot.swift
//  
//
//  Created by Riccardo Cipolleschi on 19/11/21.
//

import Foundation
import SwiftUI
import PokedexPkg
import PokemonList
import PokemonDetails
import Combine

public enum CompositionRoot {
    
    public static var composeApp: some View {
        return NavigationView {
            PokedexList<PokemonList>(
                pokedexService: MockedPokedexService(),
                pokedexDetailsProvider: goToPokemonList
            )
        }
    }
    
    private static func goToPokemonList(pokedexId: Int, pokedexName: String) -> PokemonList<PokemonDetails> {
        return PokemonList(
            pokedexId: pokedexId,
            pokedexName: pokedexName,
            pokemonService: MockedPokemonService(),
            pokemonDetailsProvider: goToPokemonDetails
        )
    }
    
    private static func goToPokemonDetails(pokemonId: Int, pokemonName: String) -> PokemonDetails {
        return PokemonDetails(
            pokemonId: pokemonId,
            pokemonName: pokemonName,
            pokemonService: MockedPokemonDetailsService()
        )
    }
}

extension CompositionRoot {
    class MockedPokedexService: PokedexService {
        func getPokedexes(callback: (Result<[PokedexModel], Error>) -> ()) {
            callback(.success([
                .init(id: 1, name: "Kanto", numberOfPokemon: 151),
                .init(id: 2, name: "Johto", numberOfPokemon: 251)
            ]))
        }
    }
    
    class MockedPokemonService: PokemonService {
        func getPokemons(pokedexId: Int) -> AnyPublisher<[Pokemon], Error> {
            return Just([
                Pokemon(id: 1, name: "Bulbasaur", sprite: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!),
                Pokemon(id: 2, name: "Ivysaur", sprite: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png")!),
                Pokemon(id: 3, name: "Venusaur", sprite: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png")!)
            ])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    class MockedPokemonDetailsService: PokemonDetailsService {
        func getPokemon(id: Int) async throws -> PokemonDetail {
            return .init(
                id: id,
                name: "Bulbasaur",
                image: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")!,
                description: "A strange seed was planted on its back at birth. The plant sprouts and grows with this POKéMON."
            )
        }
    }
}
