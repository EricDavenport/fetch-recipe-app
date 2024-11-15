import Foundation
import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes = [Recipe]()
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager = NetworkManager.shared

    func loadRecipes() async {
        isLoading = true
        errorMessage = nil

        do {
            // 'recipes' is already an array, so no further transormationis required
            recipes = try await networkManager.fetchRecipes(from: Constants.allRecipeURL)
        } catch let error as CustomError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = CustomError.unknownError.localizedDescription
        }

        isLoading = false
    }
}
