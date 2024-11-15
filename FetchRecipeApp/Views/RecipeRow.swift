import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    @StateObject private var imageLoader = ImageCacheManager.shared

    var body: some View {
        HStack(spacing: 16) {
            // Thumbnail Image with placeholder
            AsyncImageView(url: recipe.photoURLSmall!)
                .frame(width: 60, height: 60)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                // Recipe Name
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                // Cuising Type
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.vertical, 8)
        }
    }
}

struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRow(recipe: Recipe(
            id: "8938f16a-954c-4d65-953f-fa069f3f1b0d",
            cuisine: "British",
            name: "Blackberry Fool",
            photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/small.jpg",
            photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/large.jpg"
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
