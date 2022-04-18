//
//  ContentView.swift
//  VedangMapPractice
//
//  Created by Stephen Dowless on 3/30/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var viewModel = MapViewModel()
    
    var body: some View {
        VStack {
            MapViewRepresentable(viewModel: viewModel)
                .ignoresSafeArea()
            
            VStack {
                List(viewModel.locations) { location in
                    Button {
                        // generate polyline and display on map here..
                        viewModel.selectLocation(location: location)
                    } label: {
                        Text(location.addressString)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
