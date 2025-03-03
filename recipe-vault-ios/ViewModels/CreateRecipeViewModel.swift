import Foundation

@MainActor
class CreateRecipeViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var ingredients: [String] = [""]
    @Published var instructions: [String] = [""]
    @Published var imageUrl: String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let api = RecipeAPI()
    
    // Validierung der Eingaben
    var isFormValid: Bool {
        !title.isEmpty && 
        !description.isEmpty && 
        !ingredients.isEmpty && ingredients.allSatisfy({ !$0.isEmpty }) &&
        !instructions.isEmpty && instructions.allSatisfy({ !$0.isEmpty })
    }
    
    // Hinzufügen einer neuen leeren Zutat
    func addIngredient() {
        ingredients.append("")
    }
    
    // Löschen einer Zutat
    func removeIngredient(at index: Int) {
        guard ingredients.count > 1 else { return }
        ingredients.remove(at: index)
    }
    
    // Hinzufügen einer neuen leeren Anweisung
    func addInstruction() {
        instructions.append("")
    }
    
    // Löschen einer Anweisung
    func removeInstruction(at index: Int) {
        guard instructions.count > 1 else { return }
        instructions.remove(at: index)
    }
    
    // Speichern des Rezepts
    func saveRecipe() async {
        // Entferne leere Einträge
        let filteredIngredients = ingredients.filter { !$0.isEmpty }
        let filteredInstructions = instructions.filter { !$0.isEmpty }
        
        guard !filteredIngredients.isEmpty && !filteredInstructions.isEmpty else {
            errorMessage = "Bitte füge mindestens eine Zutat und eine Anweisung hinzu."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let dto = CreateRecipeDTO(
            title: title, 
            description: description, 
            ingredients: filteredIngredients, 
            instructions: filteredInstructions,
            imageUrl: imageUrl.isEmpty ? nil : imageUrl
        )
        
        do {
            _ = try await api.createRecipe(recipe: dto)
            successMessage = "Rezept erfolgreich gespeichert!"
            
            // Formular zurücksetzen
            resetForm()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // Zurücksetzen des Formulars
    func resetForm() {
        title = ""
        description = ""
        ingredients = [""]
        instructions = [""]
        imageUrl = ""
        errorMessage = nil
        successMessage = nil
    }
}
