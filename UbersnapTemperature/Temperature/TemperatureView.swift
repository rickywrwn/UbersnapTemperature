//
//  TemperatureView.swift
//  UbersnapTemperature
//
//  Created by ricky wirawan on 09/03/25.
//

import SwiftUI
//import UIKit

struct TemperatureView: View {
    @StateObject private var viewModel: TemperatureViewModel
    @State private var showingErrorAlert = false
    
    init(selectedImageData: Data) {
        _viewModel = StateObject(wrappedValue: TemperatureViewModel(imageData: selectedImageData))
    }
    
    var body: some View {
        VStack {
            
            Text("Adjust Temperature")
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.black)
                .padding()
            
            if let image = viewModel.displayImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(10)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    .padding(.vertical, 20)
            } else {
                Text("No image selected")
                    .padding()
            }
            
            // Temperature slider
            VStack(alignment: .center) {
                
                Text("Temperature: \(Int(viewModel.temperature))")
                    .font(.subheadline)
                    .foregroundStyle(.black)
                
                HStack{
                    VStack{
                        Text("Cool")
                        Text("-100")
                    }
                    Slider(value: $viewModel.temperature, in: -100...100, step: 1)
                        .onChange(of: viewModel.temperature) { _, _ in
                            viewModel.updateImageTemperature()
                        }
                    VStack{
                        Text("Warm")
                        Text("100")
                    }
                }
            }
            .padding()
            
            Button(action: {
                viewModel.saveImage()
            }) {
                Text("Save Image")
                    .padding()
                    .foregroundStyle(.black)
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 1)
            )
            
            if viewModel.saveSuccess {
                Text("Image saved successfully!")
                    .foregroundColor(.green)
                    .padding(.top, 8)
            }
        }
        .padding()
        .background(.white)
        .onChange(of: viewModel.saveError != nil) { hasErrorOld, hasError in
            showingErrorAlert = hasError
        }
        .alert(isPresented: $showingErrorAlert, content: {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.saveError?.localizedDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        })
    }
}
