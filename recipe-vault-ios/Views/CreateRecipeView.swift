import SwiftUI

struct CreateRecipeView: View {
    @StateObject private var viewModel = CreateRecipeViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Allgemeine Informationen")) {
                    TextField("Titel", text: $viewModel.title)
                    
                    TextField("Beschreibung", text: $viewModel.description)
                        .frame(height: 100)
                }
                
                Section(header: Text("Zutaten")) {
                    ForEach(0..<viewModel.ingredients.count, id: \.self) { index in
                        HStack {
                            TextField("Zutat \(index + 1)", text: $viewModel.ingredients[index])
                            
                            if viewModel.ingredients.count > 1 {
                                Button(action: {
                                    viewModel.removeIngredient(at: index)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        viewModel.addIngredient()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Zutat hinzufügen")
                        }
                    }
                }
                
                Section(header: Text("Zubereitung")) {
                    ForEach(0..<viewModel.instructions.count, id: \.self) { index in
                        HStack {
                            TextField("Schritt \(index + 1)", text: $viewModel.instructions[index])
                                .frame(height: 60)
                            
                            if viewModel.instructions.count > 1 {
                                Button(action: {
                                    viewModel.removeInstruction(at: index)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        viewModel.addInstruction()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Schritt hinzufügen")
                        }
                    }
                }
                
                Section(header: Text("Optionale Angaben")) {
                    TextField("Bild-URL", text: $viewModel.imageUrl)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                
                if let successMessage = viewModel.successMessage {
                    Section {
                        Text(successMessage)
                            .foregroundColor(.green)
                    }
                }
                
                Section {
                    Button(action: {
                        Task {
                            await viewModel.saveRecipe()
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Rezept speichern")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                }
            }
            .navigationTitle("Neues Rezept")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
        }
    }
}
