import SwiftUICore
import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Lade Rezepte...")
                } else if let errorMessage = viewModel.errorMessage {
                                    VStack {
                                        Text(errorMessage)
                                            .foregroundColor(.red)
                                        Button("Erneut versuchen") {
                                            viewModel.loadRecipes()
                                        }
                                    }
                                } else {
                    List(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRowView(recipe: recipe)
                        }
                    }
                }
            }
            .navigationTitle("Meine Rezepte")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Hier später: Neues Rezept erstellen
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadRecipes()
        }
    }
}
