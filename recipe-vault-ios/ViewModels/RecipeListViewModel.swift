import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let api = RecipeAPI()
    
    func loadRecipes() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                recipes = try await api.fetchRecipes()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
