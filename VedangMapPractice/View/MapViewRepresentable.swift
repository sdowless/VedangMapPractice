//
//  MapViewRepresentable.swift
//  VedangMapPractice
//
//  Created by Stephen Dowless on 3/30/22.
//

import SwiftUI
import MapKit

/*
 
We use a UIKit map view becuase it has more functionality that SwiftUI Maps.
The UIViewRepresentable protocol allows us to transform a UIKit view into a SwiftUI View.
 
*/

struct MapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    let imagePicker = UIImagePickerController()
    @StateObject var locationManager = LocationManager()
    
    func makeUIView(context: Context) -> some UIView {
        mapView.isRotateEnabled = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        if let coordinate = locationManager.userLocation?.coordinate {
            
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                                                       longitudeDelta: 0.05))
            
            print("DEBUG: Did set region \(region)")
            mapView.setRegion(region, animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: MapViewRepresentable
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
        }
    }
}
