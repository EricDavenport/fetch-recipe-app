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

//#Preview {
//    RecipeRow()
//}
// Preview for SwiftUI Canvas
struct RecipeRow_Previews: PreviewProvider {
    static var previews: some View {
        RecipeRow(recipe: Recipe(
            id: "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
            cuisine: "Italian",
            name: "Spaghetti Carbonara",
            photoURLSmall: "https://some.url/small.jpg",
            photoURLLarge: "https://some.url/large.jpg"
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
