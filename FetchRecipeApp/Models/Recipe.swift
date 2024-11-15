import Foundation

struct RecipeResponse: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Identifiable, Codable {
    let id: String
    let cuisine: String
    let name: String
    let photoURLSmall: String?
    let photoURLLarge: String?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
    }
}
