import Foundation
import SwiftUI

class ImageCacheManager: ObservableObject {
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let diskCacheDirectory: URL

    static let shared = ImageCacheManager()

    private init() {
        // setting up the directory for the disk caching
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheDirectory = cachesDirectory.appendingPathComponent("ImageCache")

        // Create directory if it doesnt exist
        if !fileManager.fileExists(atPath: diskCacheDirectory.path) {
            try? fileManager
                .createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
        }
    }

    func fetchImage(from urlString: String) async throws -> UIImage {
        let cacheKey = NSString(string: urlString)

        // Check memeory cache
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }

        // Check disk cache
        if let diskCacheImage = try loadImageFromDisk(forKey: urlString) {
            // Store it back to memory cache for faster access next time
            cache.setObject(diskCacheImage, forKey: cacheKey)
            return diskCacheImage
        }

        // Download the image if not cached
        let downloadedImage = try await downloadImage(from: urlString)

        // cache image in memory and on disk
        cache.setObject(downloadedImage, forKey: cacheKey)
        try saveImageToDisk(downloadedImage, forKey: urlString)

        return downloadedImage
    }

    private func downloadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw CustomError.imageNotFound
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw CustomError.badData
            }

            guard let image = UIImage(data: data) else {
                throw CustomError.imageNotFound
            }

            return image
        } catch {
            throw CustomError.cacheError
        }
    }

    private func saveImageToDisk(_ image: UIImage, forKey key: String) throws {
        guard let data = image.pngData() else {
            throw CustomError.imageNotFound
        }

        let fileURL = diskCacheDirectory.appendingPathComponent(keyToFilename(key))

        do {
            try data.write(to: fileURL)
        } catch {
            throw CustomError.cacheError
        }

    }

    private func loadImageFromDisk(forKey key: String) throws -> UIImage? {
        let fileURL = diskCacheDirectory.appendingPathComponent(keyToFilename(key))

        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw CustomError.imageNotFound
        }

        do {
            let data = try Data(contentsOf: fileURL)
            guard let image = UIImage(data: data) else {
                throw CustomError.imageNotFound
            }
            return image
        } catch {
            throw CustomError.cacheError
        }
    }

    private func keyToFilename(_ key: String) -> String {
        return key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
    }
}
