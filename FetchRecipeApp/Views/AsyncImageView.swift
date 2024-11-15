import Foundation
import SwiftUI

struct AsyncImageView: View {
    let url: String
    @State private var image: UIImage? = nil
    @State private var isLoading = true
    @State private var loadError: CustomError? = nil

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if isLoading {
                ProgressView()
                    .frame(width: 60, height: 60)
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .frame(width: 60, height: 60)
                    .onTapGesture {
                        Task { await loadImage() } // Retry on tap
                    }
            }
        }
        .onAppear {
            Task{ await loadImage() }
        }
    }

    private func loadImage() async {
        isLoading = true
        loadError = nil

        do {
            image = try await ImageCacheManager.shared.fetchImage(from: url)
        } catch let error as CustomError {
            loadError = error
            image = nil
        } catch {
            loadError = .unknownError
            image = nil
        }
        isLoading = false
    }
}


struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Success State Preview
            AsyncImageView(url: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
                .previewDisplayName("Image Loaded Successfully")
                .frame(width: 100, height: 100)

            // Loading State Preview
            AsyncImageView(url: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
                .previewDisplayName("Loading State")
                .frame(width: 100, height: 100)

            // Error State Preview (invalid URL)
            AsyncImageView(url: "invalid-url")
                .previewDisplayName("Error State")
                .frame(width: 100, height: 100)
        }
    }
}
