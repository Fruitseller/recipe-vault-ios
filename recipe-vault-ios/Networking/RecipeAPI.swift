import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidData
    case networkError(Error)
}

class RecipeAPI {
    private let baseURL = "http://127.0.0.1:8000"
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: "\(baseURL)/recipes") else {
            throw APIError.invalidResponse
        }
        
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        // Decode die API-Response-Struktur
        let apiResponse = try JSONDecoder().decode(APIResponse<[Recipe]>.self, from: data)
        return apiResponse.data
    }
}

// Wir brauchen einen eigenen Decoder für das API-Response-Format
struct APIResponse<T: Codable>: Codable {
    let data: T
    let timestamp: String
}
