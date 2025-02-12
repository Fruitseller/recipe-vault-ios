import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case serverError(Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Ungültige URL"
        case .invalidResponse:
            return "Ungültige Server-Antwort"
        case .invalidData:
            return "Ungültige Daten vom Server"
        case .serverError(let code):
            return "Server-Fehler: \(code)"
        case .decodingError(let error):
            return "Fehler beim Dekodieren: \(error.localizedDescription)"
        }
    }
}

class RecipeAPI {
    private let baseURL = "http://127.0.0.1:8000"
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: "\(baseURL)/recipes") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Datum konnte nicht im Format \(dateString) geparst werden"
            )
        }
        
        do {
            let apiResponse = try decoder.decode(APIResponse<[Recipe]>.self, from: data)
            return apiResponse.data
        } catch {
            print("Decodierung fehlgeschlagen mit Fehler:")
            print(error)
            throw APIError.decodingError(error)
        }
    }
}

struct APIResponse<T: Codable>: Codable {
    let data: T
    let timestamp: String
}
