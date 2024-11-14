import Foundation

enum CustomError: LocalizedError {
    case networkError
    case badData
    case emptyData
    case malformedData
    case unknownData

    var errorDescription: String? {
        switch self {
            case .networkError:
                return "Network connection issue. Please check your internet connection."
            case .badData:
                return "Failed to load recipes due to data issues"
            case .emptyData:
                return "No recipes available at the moment."
            case .malformedData:
                return "Data received from the server was malformed."
            case .unknownData:
                return "An unknown error occurred. Please try again later."
        }
    }
}

