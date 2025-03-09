//
//  SaveError.swift
//  UbersnapTemperature
//
//  Created by ricky wirawan on 09/03/25.
//

enum SaveError: Error, LocalizedError {
    case saveFailed
    case loadFailed
    case convertJPEGFailed
    case permissionDenied
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save image."
        case .loadFailed:
            return "Failed to load image."
        case .convertJPEGFailed:
            return "Failed to convert to JPEG"
        case .permissionDenied:
            return "Permission to access photo library was denied."
        case .unknown(let error):
            return "An error occurred: \(error.localizedDescription)"
        }
    }
}

