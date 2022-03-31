//
//  ContentView.swift
//  VedangMapPractice
//
//  Created by Stephen Dowless on 3/30/22.
//

import SwiftUI
import MapKit

struct ContentView: View {    
    var body: some View {
        MapViewRepresentable()
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
