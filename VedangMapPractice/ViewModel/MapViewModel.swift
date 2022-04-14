//
//  MapViewModel.swift
//  VedangMapPractice
//
//  Created by Stephen Dowless on 4/5/22.
//

import CoreLocation
import MapKit

class MapViewModel: ObservableObject {
    
    /*
     This uses the shared instance of our location manager
     so we don't have to worry about passing the LocationManager
     and its associated data from view to view in our app.
     */
    var userLocation = LocationManager.shared.userLocation
    @Published var destinationPlacemark: MKPlacemark?
    
    var addresses: [String] = [
        "1976 Bascom Ave, Campbell, CA"
//        "1696 Tully Rd, San Jose, CA"
    ]
    
    var locationDistanceDict = [String: Double]()
    
    init() {        
        addresses.forEach { address in
            calculateRouteDistance(toAddress: address)
        }
    }
    
    func calculateRouteDistance(toAddress address: String) {
        let geocoder = CLGeocoder()
        guard let userLocation = userLocation else {
            return
        }
        
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let endPlacemark = placemarks?.first else { return }
            guard let coordinate = endPlacemark.location?.coordinate else { return }
            self.destinationPlacemark = MKPlacemark(coordinate: coordinate)
            
            let start = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
            let end = MKMapItem(placemark: MKPlacemark(coordinate: endPlacemark.location!.coordinate))
            
            // directions request between two points
            let request: MKDirections.Request = MKDirections.Request()
            request.source = start
            request.destination = end
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate(completionHandler: { (response: MKDirections.Response?, error: Error?) in
                // Now we should have a route.
                if let routes = response?.routes {
                    let route = routes[0]
//                    print("DEBUG: Distance between points is \(route.distance)")
                    
                    self.locationDistanceDict[address] = route.distance
                    
//                    print("DEBUG: Location distances \(self.locationDistanceDict)")

                }
            })
        }
        
        
    }
    
}
