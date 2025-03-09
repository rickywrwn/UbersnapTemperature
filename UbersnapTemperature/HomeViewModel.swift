//
//  HomeViewModel.swift
//  UbersnapTemperature
//
//  Created by ricky wirawan on 09/03/25.
//

import SwiftUI
import PhotosUI

class HomeViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? = nil {
        didSet {
            loadImageData()
        }
    }
    @Published var selectedImageData: Data? = nil
    @Published var imageError: ImageError? = nil
    
    private func loadImageData() {
        // Reset error state when starting a new load
        imageError = nil
        selectedImageData = nil
        
        guard selectedItem != nil else { return }
        
        Task { [weak self] in
            do {
                if let data = try await self?.selectedItem?.loadTransferable(type: Data.self) {
                    // Verify the image data is valid and in JPEG format
                    if let image = UIImage(data: data) {
                        // Check if image is in JPEG format by examining data signature
                        // JPEG files start with FF D8 FF
                        if data.count >= 3 && data[0] == 0xFF && data[1] == 0xD8 && data[2] == 0xFF {
                            DispatchQueue.main.async {
                                self?.selectedImageData = data
                            }
                        } else {
                            throw ImageError.invalidFormat
                        }
                    } else {
                        throw ImageError.loadFailed
                    }
                } else {
                    throw ImageError.loadFailed
                }
            } catch let error as ImageError {
                DispatchQueue.main.async {
                    self?.imageError = error
                }
            } catch {
                DispatchQueue.main.async {
                    self?.imageError = .unknown(error)
                }
            }
        }
    }
    
    var hasSelectedImage: Bool {
        selectedImageData != nil && UIImage(data: selectedImageData!) != nil
    }
    
    func getUIImage() -> UIImage? {
        if let data = selectedImageData {
            return UIImage(data: data)
        }
        return nil
    }
}
