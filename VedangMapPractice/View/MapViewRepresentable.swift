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
    @StateObject var locationManager = LocationManager.shared
    @StateObject var viewModel = MapViewModel()
    
    func makeUIView(context: Context) -> some UIView {
        mapView.isRotateEnabled = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = context.coordinator
        
        if let coordinate = locationManager.userLocation?.coordinate {
            
            let region = MKCoordinateRegion(center: coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                                   longitudeDelta: 0.05))
            
            mapView.setRegion(region, animated: true)
            
        }
        
        return mapView
    }
    
    // this function gets called everytime the view wants to update (publishers, notifications, etc.)
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let destinationPlacemark = viewModel.destinationPlacemark else { return }
        context.coordinator.generatePolyline(forPlacemark: destinationPlacemark)
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        // MARK: - Properties
        
        let parent: MapViewRepresentable
        
        // MARK: - Lifecycle
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        // MARK: - MKMapViewDelegate Protocol Functions
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let overlay = MKPolylineRenderer(overlay: overlay)
            overlay.strokeColor = .systemBlue
            overlay.lineWidth = 6
            return overlay
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let anno = annotation as? MKPointAnnotation {
                let view = MKAnnotationView(annotation: anno, reuseIdentifier: "anno")
                return view
            }
            
            return nil
        }
        
        // MARK: - Helpers
        
        func generatePolyline(forPlacemark destinationPlacemark: MKPlacemark) {
            guard let userLocation = LocationManager.shared.userLocation else { return }
            let userPlacemark = MKPlacemark(coordinate: userLocation.coordinate)
            
            print("DEBUG: User location is \(userLocation)")
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destinationPlacemark)
            
            let directions = MKDirections(request: request)
            
            print("DEBUG: Directions \(directions)")
            
            directions.calculate { response, error in
                print("DEBUG: Calculation success")
                
                if let error = error {
                    print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                    return
                }
                
                print("DEBUG: Directions response is \(response)")
                
                guard let polyline = response?.routes.first?.polyline else { return }
                print("DEBUG: Polyline is \(polyline)")
                self.parent.mapView.addOverlay(polyline)
                
                let anno = MKPointAnnotation()
                anno.coordinate = destinationPlacemark.coordinate
                self.parent.mapView.addAnnotation(anno)
                
                let rect = self.parent.mapView.mapRectThatFits(polyline.boundingMapRect,
                                                               edgePadding: .init(top: 16, left: 16, bottom: 16, right: 16))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
    }
}
