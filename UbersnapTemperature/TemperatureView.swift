//
//  TemperatureView.swift
//  UbersnapTemperature
//
//  Created by ricky wirawan on 09/03/25.
//

import SwiftUI

struct TemperatureView: View {
    
    let selectedImageData: Data
    
    var body: some View {
        VStack {
            Button(
                action: {
                    print("button")
            }) {
                Text("Choose Image")
                    .padding()
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 1)
            )
        }
        .padding()
    }
}


