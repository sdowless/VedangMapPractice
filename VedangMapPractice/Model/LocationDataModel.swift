//
//  LocationDataModel.swift
//  VedangMapPractice
//
//  Created by Stephen Dowless on 4/15/22.
//

import CoreLocation

struct LocationDataModel: Identifiable {
    let id: String = NSUUID().uuidString
    let addressString: String
    let distanceFromUser: Double
    let coordinate: CLLocationCoordinate2D
}
