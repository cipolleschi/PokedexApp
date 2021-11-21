//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Riccardo Cipolleschi on 19/11/21.
//

import SwiftUI
import Root

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            CompositionRoot.composeApp
        }
    }
}
