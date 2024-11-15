import Foundation
import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes = [Recipe]()
    @Published var isLoading = false
    @Published var vmError: CustomError?

    private let networkManager = NetworkManager.shared

    func fetchRecipes() async {
        isLoading = true
        vmError = nil

        do {
            let fetchRecipes = try await networkManager.fetchRecipes(from: Constants.allRecipeURL)
            recipes = fetchRecipes

            if recipes.isEmpty {
                vmError = .emptyData
            }
        } catch let customError as CustomError {
            vmError = customError
            recipes = []
        } catch {
            vmError = .unknownError
            recipes = []
        }

        isLoading = false
    }
}
