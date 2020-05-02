//
//  ContentView.swift
//  Bookworm
//
//  Created by Ahad Islam on 5/1/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import SwiftUI

struct PushButton: View {
    let title: String
    @Binding var isOn: Bool
    // Property wrapper that allows a two-way data flow. when isOn is triggered, it sends that data to the "binded" object as well.
    
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]
    
    
    var body: some View {
        Button(title) {
            self.isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors: offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct BindingContentView: View {
    @State private var rememberMe = false
    
    var body: some View {
        VStack {
            PushButton(title: "Remember Me", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
