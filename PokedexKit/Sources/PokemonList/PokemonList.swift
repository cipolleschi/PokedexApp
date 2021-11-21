//
//  PokemonList.swift
//  
//
//  Created by Riccardo Cipolleschi on 19/11/21.
//

import SwiftUI
import Combine

public protocol PokemonService {
    func getPokemons(pokedexId: Int) -> AnyPublisher<[Pokemon], Error>
}

public typealias PokemonDetailsProvider<Details: View> = (Int, String) -> Details

extension PokemonList {
    class ViewModel<DetailsView: View>: ObservableObject {
        @Published var pokemons: [Pokemon]
        let detailsProvider: PokemonDetailsProvider<DetailsView>
        let pokedexId: Int
        let pokedexName: String
        
        private let pokemonService: PokemonService
        private var cancellables: Set<AnyCancellable> = []
        
        
        init(
            pokedexId: Int,
            pokedexName: String,
            pokemonService: PokemonService,
            detailsProvider: @escaping PokemonDetailsProvider<DetailsView>
        ) {
            self.pokedexId = pokedexId
            self.pokedexName = pokedexName
            self.pokemons = []
            self.pokemonService = pokemonService
            self.detailsProvider = detailsProvider
        }
        
        func loadPokemons() {
            self.pokemonService
                .getPokemons(pokedexId: self.pokedexId)
                .sink(
                    receiveCompletion: { completion in
                    switch completion {
                        case .finished: print("Finished")
                        case .failure(let error): print(error)
                        }
                    }, receiveValue: { pokemons in
                        self.pokemons = pokemons
                    }
                )
                .store(in: &cancellables)
        }
    }
}

public struct PokemonList<DetailsView: View>: View {
    @StateObject var viewModel: ViewModel<DetailsView>
    
    public init(
        pokedexId: Int,
        pokedexName: String,
        pokemonService: PokemonService,
        pokemonDetailsProvider: @escaping PokemonDetailsProvider<DetailsView>
    ) {
        self._viewModel = StateObject(
            wrappedValue: ViewModel(
                pokedexId: pokedexId,
                pokedexName: pokedexName,
                pokemonService: pokemonService,
                detailsProvider: pokemonDetailsProvider
            )
        )
    }
    
    public var body: some View {
        List(self.viewModel.pokemons) { pokemon in
            NavigationLink(
                destination: {
                    self.viewModel.detailsProvider(pokemon.id, pokemon.name)
                },
                label: {
                    HStack {
                        AsyncImage(url: pokemon.sprite) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        Text(pokemon.name)
                    }
                }
            )
        }
        .navigationTitle(self.viewModel.pokedexName)
        .onAppear(perform: self.viewModel.loadPokemons)
    }
}

struct PokemonList_Previews: PreviewProvider {
    struct MockedPokemonService: PokemonService {
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
    
    static var previews: some View {
        PokemonList(
            pokedexId: 2,
            pokedexName: "Kanto",
            pokemonService: MockedPokemonService(),
            pokemonDetailsProvider: { id, name in
                return Text("Pokemon \(id) is \(name)")
                
            })
    }
}
