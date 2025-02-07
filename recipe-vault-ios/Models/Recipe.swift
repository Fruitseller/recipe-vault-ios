import Foundation

struct Recipe: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var ingredients: [String]
    var instructions: [String]
    var imageUrl: String?
    let createdAt: Date
    let updatedAt: Date
}

