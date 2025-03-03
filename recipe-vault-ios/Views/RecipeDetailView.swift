import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(recipe.description)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Zutaten")
                        .font(.headline)
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient)")
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Zubereitung")
                        .font(.headline)
                    ForEach(Array(recipe.instructions.enumerated()), id: \.element) { index, instruction in
                        Text("\(index + 1). \(instruction)")
                            .padding(.bottom, 4)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(recipe.title)
    }
}
