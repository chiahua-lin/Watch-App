//
//  MapKitExtensions.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/7/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import MapKit

extension MKCoordinateRegion {
    static func containing(coordinates: (CLLocationCoordinate2D, CLLocationCoordinate2D)) -> MKCoordinateRegion {
        let kPaddingFactor = 1.3 // Ensure that annotations are not clipped by the edge of the map

        let center = coordinates.0.halfwayPoint(location: coordinates.1)
        let latitudeDelta = abs(coordinates.0.latitude - coordinates.1.latitude) * kPaddingFactor
        let longitudeDelta = abs(coordinates.0.longitude - coordinates.1.longitude) * kPaddingFactor

        return MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
    }

    static func centeredOn(centerCoordinate: CLLocationCoordinate2D, alsoContaining outerCoordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        let kPaddingFactor = 1.3

        let latitudeDelta  = abs(centerCoordinate.latitude  - outerCoordinate.latitude)  * kPaddingFactor * 2.0
        let longitudeDelta = abs(centerCoordinate.longitude - outerCoordinate.longitude) * kPaddingFactor * 2.0

        return MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
    }
}

/** rdar 20450963 (2015-04-07): Add convenience initializer to MKPointAnnotation */
extension MKPointAnnotation {
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coordinate
    }
}
