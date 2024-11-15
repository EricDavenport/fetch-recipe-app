import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    func fetchRecipes(from urlString: String) async throws -> [Recipe] {
        guard let url = URL(string: urlString) else {
            throw CustomError.networkError
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CustomError.badData
            }

            let decoder = JSONDecoder()
            let result = try decoder.decode(RecipeResponse.self, from: data)

            if result.recipes.isEmpty {
                throw CustomError.emptyData
            }

            return result.recipes

        } catch is DecodingError {
            throw CustomError.malformedData
        } catch {
            throw CustomError.unknownError
        }
    }
}
