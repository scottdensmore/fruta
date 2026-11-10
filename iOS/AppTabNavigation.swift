/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Tab based app structure.
*/

import SwiftUI

struct AppTabNavigation: View {

    enum Tab {
        case menu
        case favorites
        case rewards
        case recipes
    }

    @EnvironmentObject private var model: Model
    @State private var selection: Tab = .menu

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                SmoothieMenu()
                    .navigationDestination(for: Smoothie.ID.self) { smoothieID in
                        if let smoothie = Smoothie(for: smoothieID) {
                            SmoothieView(smoothie: smoothie)
                                .onAppear { model.selectedSmoothieID = smoothieID }
                        }
                    }
            }
            .tabItem {
                let menuText = Text("Menu", comment: "Smoothie menu tab title")
                Label {
                    menuText
                } icon: {
                    Image(systemName: "list.bullet")
                }.accessibilityLabel(menuText)
            }
            .tag(Tab.menu)
            
            NavigationStack {
                FavoriteSmoothies()
                    .navigationDestination(for: Smoothie.ID.self) { smoothieID in
                        if let smoothie = Smoothie(for: smoothieID) {
                            SmoothieView(smoothie: smoothie)
                                .onAppear { model.selectedSmoothieID = smoothieID }
                        }
                    }
            }
            .tabItem {
                Label {
                    Text("Favorites",
                         comment: "Favorite smoothies tab title")
                } icon: {
                    Image(systemName: "heart.fill")
                }
            }
            .tag(Tab.favorites)
            
            #if EXTENDED_ALL
            NavigationStack {
                RewardsView()
            }
            .tabItem {
                Label {
                    Text("Rewards",
                         comment: "Smoothie rewards tab title")
                } icon: {
                    Image(systemName: "seal.fill")
                }
            }
            .tag(Tab.rewards)
            
            NavigationStack {
                RecipeList()
                    .navigationDestination(for: Smoothie.ID.self) { smoothieID in
                        if let smoothie = Smoothie(for: smoothieID) {
                            RecipeView(smoothie: smoothie)
                                .environmentObject(model)
                                .onAppear { model.selectedSmoothieID = smoothieID }
                        }
                    }
            }
            .tabItem {
                Label {
                    Text("Recipes",
                         comment: "Smoothie recipes tab title")
                } icon: {
                    Image(systemName: "book.closed.fill")
                }
            }
            .tag(Tab.recipes)
            #endif
        }
    }
}

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
            .environmentObject(Model())
    }
}
