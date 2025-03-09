//
//  HomeView.swift
//  UbersnapTemperature
//
//  Created by ricky wirawan on 09/03/25.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingErrorAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Ubersnap")
                    .font(.system(size: 30, weight: .bold))
                Text("Image Temperature Control")
                    .font(.system(size: 23, weight: .bold))
                
                PhotosPicker(
                    selection: $viewModel.selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Text("Choose Image")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                    }
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 1)
                    )
                
                if viewModel.hasSelectedImage, let uiImage = viewModel.getUIImage() {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                    
                    NavigationLink {
                        TemperatureView(selectedImageData: viewModel.selectedImageData ?? Data())
                    } label: {
                        Text("Adjust Temperature")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                    }
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 1)
                    )
                }
                
                Spacer()
            }
            .padding()
            .onChange(of: viewModel.imageError != nil) { hasErrorOld, hasError in
                showingErrorAlert = hasError
            }
            .alert(isPresented: $showingErrorAlert, content: {
                Alert(
                    title: Text("Image Error"),
                    message: Text(viewModel.imageError?.localizedDescription ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            })
        }
    }
}

#Preview {
    HomeView()
}

