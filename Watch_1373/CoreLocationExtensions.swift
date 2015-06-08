//
//  CoreLocationExtensions.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/7/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D : Printable {
    public var description: String {
        return "CLLocationCoordinate2D<lat: \(self.latitude), lng: \(self.longitude)>"
    }
}

extension CLLocationCoordinate2D {
    func distanceFrom(location: CLLocationCoordinate2D) -> CLLocationDistance {
        let here = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let there = CLLocation(latitude: location.latitude, longitude: location.longitude)
        return here.distanceFromLocation(there)
    }
}

/* Adapted from
 * http://stackoverflow.com/questions/6671183/calculate-the-center-point-of-multiple-latitude-longitude-coordinate-pairs
 */
extension CLLocationCoordinate2D {
    // These methods are marked private because they abuse CLLocationCoordinate2D to hold radians rather than degrees.
    private func toRadians()   -> CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: latitude * M_PI / 180, longitude: longitude * M_PI / 180) }
    private func fromRadians() -> CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: latitude / M_PI * 180, longitude: longitude / M_PI * 180) }

    func halfwayPoint(location other: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let a = self.toRadians(), b = other.toRadians()

        let x = ((cos(a.latitude) * cos(a.longitude)) + (cos(b.latitude) * cos(b.longitude))) / 2
        let y = ((cos(a.latitude) * sin(a.longitude)) + (cos(b.latitude) * sin(b.longitude))) / 2
        let z = (sin(a.latitude) + sin(b.latitude)) / 2
        let r = sqrt(x * x + y * y)

        return CLLocationCoordinate2D(latitude: atan2(z, r), longitude: atan2(y, x)).fromRadians()
    }
}

private let kMetersPerInch = 0.0254
private let kMetersPerFoot = 0.3048
private let kMetersPerYard = 0.9144
private let kMetersPerMile = 1609.34

struct CLLocationDistanceConverter {
    

    let meters: Double

    var inches: Double { return meters / kMetersPerInch }
    var feet:   Double { return meters / kMetersPerFoot }
    var yards:  Double { return meters / kMetersPerYard }
    var miles:  Double { return meters / kMetersPerMile }

    init(meters: Double) { self.meters = meters }
    init(inches: Double) { meters = inches * kMetersPerInch }
    init(feet:   Double) { meters = feet * kMetersPerFoot }
    init(yards:  Double) { meters = yards * kMetersPerYard }
    init(miles:  Double) { meters = miles * kMetersPerMile }
}
