/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app's navigation with a configuration that offers a sidebar, content list, and detail pane.
*/

import SwiftUI

struct AppSidebarNavigation: View {

    enum NavigationItem: Hashable {
        case menu
        case favorites
        case recipes
    }

    @EnvironmentObject private var model: Model
    @State private var presentingRewards: Bool = false
    @State private var selection: NavigationItem? = .menu
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink(value: NavigationItem.menu) {
                    Label("Menu", systemImage: "list.bullet")
                }
                
                NavigationLink(value: NavigationItem.favorites) {
                    Label("Favorites", systemImage: "heart")
                }
            
                #if EXTENDED_ALL
                NavigationLink(value: NavigationItem.recipes) {
                    Label("Recipes", systemImage: "book.closed")
                }
                #endif
            }
            .navigationTitle("Fruta")
            #if EXTENDED_ALL
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Pocket()
            }
            #endif
        } content: {
            switch selection {
            case .menu:
                SmoothieMenu()
            case .favorites:
                FavoriteSmoothies()
            #if EXTENDED_ALL
            case .recipes:
                RecipeList()
            #endif
            default:
                Text("Select a category")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background()
                    .ignoresSafeArea()
            }
        } detail: {
            if let smoothieID = model.selectedSmoothieID, let smoothie = Smoothie(for: smoothieID) {
                #if EXTENDED_ALL
                if selection == .recipes {
                    RecipeView(smoothie: smoothie)
                        .environmentObject(model)
                } else {
                    SmoothieView(smoothie: smoothie)
                }
                #else
                SmoothieView(smoothie: smoothie)
                #endif
            } else {
                Text("Select a smoothie")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background()
                    .ignoresSafeArea()
                    .toolbar {
                        SmoothieFavoriteButton()
                            .environmentObject(model)
                            .disabled(true)
                    }
            }
        }
    }
    
    struct Pocket: View {
        @State private var presentingRewards: Bool = false
        @EnvironmentObject private var model: Model
        
        var body: some View {
            Button(action: { presentingRewards = true }) {
                Label("Rewards", systemImage: "seal")
            }
            .controlSize(.large)
            .buttonStyle(.capsule)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .sheet(isPresented: $presentingRewards) {
                RewardsView()
                    #if os(iOS)
                    .overlay(alignment: .topTrailing) {
                        Button(action: { presentingRewards = false }) {
                            Text("Done", comment: "Button title to dismiss rewards sheet")
                        }
                        .font(.body.bold())
                        .keyboardShortcut(.defaultAction)
                        .buttonStyle(.capsule)
                        .padding()
                    }
                    #else
                    .frame(minWidth: 400, maxWidth: 600, minHeight: 400, maxHeight: 600)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: { presentingRewards = false }) {
                                Text("Done", comment: "Button title to dismiss rewards sheet")
                            }
                        }
                    }
                    #endif
            }
        }
    }
}

struct AppSidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation()
            .environmentObject(Model())
    }
}

struct AppSidebarNavigationPocket_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation.Pocket()
            .environmentObject(Model())
            .frame(width: 300)
    }
}
