import Foundation

struct CreateRecipeDTO: Codable {
    var title: String
    var description: String
    var ingredients: [String]
    var instructions: [String]
    var imageUrl: String?
}
