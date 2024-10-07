//
//  AlertView.swift
//  WeatherApp
//
//  Created by Rahul Avale on 10/6/24.
//

import SwiftUI

struct AlertView: ViewModifier {
    @Binding var isPresented: Bool
    let error: WeatherError
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(title: Text("Error"), message: Text(error.localizedDescription))
            }
    }
}

extension View {
    func alert(isPresented: Binding<Bool>, for error: WeatherError) -> some View {
        self.modifier(AlertView(isPresented: isPresented, error: error))
    }
}
