//
//  TemperatureViewModel.swift
//  UbersnapTemperature
//
//  Created by ricky wirawan on 09/03/25.
//

import Foundation
import PhotosUI

class TemperatureViewModel: NSObject, ObservableObject {
    @Published var temperature: Float = 0
    @Published var displayImage: UIImage?
    @Published var originalImage: UIImage?
    @Published var saveSuccess: Bool = false
    @Published var saveError: SaveError? = nil
    
    init(imageData: Data) {
        if let image = UIImage(data: imageData) {
            self.originalImage = image
            self.displayImage = image
        } else {
            self.saveError = .loadFailed
        }
    }
    
    func updateImageTemperature() {
        guard let original = originalImage else {
            self.saveError = .loadFailed
            return
        }
        
        // Store the original orientation
        let originalOrientation = original.imageOrientation
        
        // Use OpenCV wrapper to adjust temperature
        let adjustedImage = OpenCVWrapper.adjustTemperature(original, withTemperature: temperature)
        
        // Create a new UIImage with the adjusted image data but preserving the original orientation
        if originalOrientation != .up {
            // Only create a new image if orientation isn't already up (default)
            if let cgImage = adjustedImage.cgImage {
                displayImage = UIImage(cgImage: cgImage, scale: adjustedImage.scale, orientation: originalOrientation)
            } else {
                displayImage = adjustedImage
            }
        } else {
            displayImage = adjustedImage
        }
    }
    
    func saveImage() {
        guard let imageToSave = displayImage else {
            self.saveError = .saveFailed
            return
        }
        
        // Check photo library permission status
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            // Request permission
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                if newStatus == .authorized {
                    // Permission granted, proceed with saving
                    DispatchQueue.main.async {
                        self?.processSaveImage(imageToSave)
                    }
                } else {
                    // Permission denied
                    DispatchQueue.main.async {
                        self?.saveError = .permissionDenied
                    }
                }
            }
        case .authorized:
            // Already have permission, proceed with saving
            processSaveImage(imageToSave)
        case .denied, .restricted, .limited:
            // Permission denied or restricted
            saveError = .permissionDenied
        @unknown default:
            // Handle future cases
            saveError = .unknown(NSError(domain: "PHPhotoLibrary", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown authorization status"]))
        }
    }

    private func processSaveImage(_ imageToSave: UIImage) {
        // Convert UIImage to JPEG data with 0.9 quality
        guard let imageData = imageToSave.jpegData(compressionQuality: 0.9) else {
            self.saveError = .convertJPEGFailed
            return
        }

        // Get the documents directory
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            self.saveError = .loadFailed
            return
        }

        // Create a unique filename with timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let fileName = "temperature_adjusted_\(dateFormatter.string(from: Date())).jpeg"

        // Create the file URL
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        // Write the data to the file
        do {
            try imageData.write(to: fileURL)
            print("Image saved successfully at: \(fileURL.path)")

            // Release imageData explicitly
            let savedImage = UIImage(contentsOfFile: fileURL.path) ?? imageToSave

            // Add to photo library using a weak self reference
            UIImageWriteToSavedPhotosAlbum(savedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

        } catch {
            self.saveError = .saveFailed
        }
    }

    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            if let error = error {
                if let phError = error as? PHPhotosError {
                    switch phError.code {
                    case .accessUserDenied:
                        self.saveError = .permissionDenied
                    default:
                        self.saveError = .saveFailed
                    }
                } else {
                    self.saveError = .unknown(error)
                }
            } else {
                self.saveSuccess = true
                // Reset success message after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.saveSuccess = false
                }
            }
        }
    }
}
