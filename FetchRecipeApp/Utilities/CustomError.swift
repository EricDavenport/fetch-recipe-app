import Foundation

enum CustomError: LocalizedError {
    case networkError
    case badData
    case emptyData
    case malformedData
    case imageNotFound
    case cacheError
    case unknownError

    var errorDescription: String? {
        switch self {
            case .networkError:
                return "Network connection issue. Please check your internet connection."
            case .badData:
                return "Failed to load recipes due to data issues."
            case .emptyData:
                return "No recipes available at the moment."
            case .malformedData:
                return "Data received from the server was malformed."
            case .imageNotFound:
                return "Failed to load the image."
            case .cacheError:
                return "Failed to cache the image."
            case .unknownError:
                return "An unknown error occurred. Please try again later."
        }
    }
}

