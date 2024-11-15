import Foundation
import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // Main List View
                if viewModel.recipes.isEmpty && !viewModel.isLoading {
                    // Display empty state if reciped list is empty
                    emptyStateView
                } else {
                    recipeListView
                }

                if let error = viewModel.vmError {
                    errorView(for: error)
                }

                if viewModel.isLoading {
                    loadingView
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                // Refresh button in navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.fetchRecipes()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .refreshable {
                // pull to refresh
                await viewModel.fetchRecipes()
            }
            .onAppear {
                Task {
                    await viewModel.fetchRecipes()
                }
            }
        }
    }

    private var recipeListView: some View {
        List(viewModel.recipes, id: \.id) { recipe in
            RecipeRow(recipe: recipe)
        }
        .listStyle(PlainListStyle())
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Text("No Recipe Available")
                .font(.title2)
                .foregroundColor(.gray)

            Button(action: {
                Task {
                    await viewModel.fetchRecipes()
                }
            }) {
                Text("Refresh")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    private func errorView(for error: CustomError) -> some View {
        VStack(spacing: 16) {
            Text(error.localizedDescription)
                .font(.title2)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)

            Button(action: {
                Task {
                    await viewModel.fetchRecipes()
                }
            }) {
                Text("Try Again")
                    .font(.headline)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    private var loadingView: some View {
        VStack {
            ProgressView(" Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .font(.title2)
        }
    }
}

#Preview {
    RecipeListView()
}
