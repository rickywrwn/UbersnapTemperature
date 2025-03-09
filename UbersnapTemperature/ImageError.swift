//
//  ImageError.swift
//  UbersnapTemperature
//
//  Created by ricky wirawan on 09/03/25.
//

import Foundation

enum ImageError: Error, LocalizedError {
    case invalidFormat
    case loadFailed
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidFormat:
            return "The selected image must be in JPEG format."
        case .loadFailed:
            return "Failed to load the selected image."
        case .unknown(let error):
            return "An error occurred: \(error.localizedDescription)"
        }
    }
}
