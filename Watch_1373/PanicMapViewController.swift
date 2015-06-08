//
//  PanicMapViewController.swift
//  Watch_1373
//
//  Created by William LaFrance on 4/7/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit
import MapKit

enum PanicMapLocationTag {
    case User
    case Panic
}

class PanicMapAnnotation: MKPointAnnotation {
    let tag: PanicMapLocationTag

    init(coordinate: CLLocationCoordinate2D, tag: PanicMapLocationTag) {
        self.tag = tag
        super.init()
        self.coordinate = coordinate
    }
}

class PanicMapViewController: UIViewController, MKMapViewDelegate {

    let userLocation  = CLLocationCoordinate2D(latitude: 43.038021, longitude: -89.382439) /* LSR Madison */
    let panicLocation = CLLocationCoordinate2D(latitude: 43.092222, longitude: -89.337615) /* 3225 Atwood Ave */

    @IBOutlet weak var map: MKMapView! {
        didSet {
            map.delegate = self
        }
    }

    @IBOutlet weak var lastActivatedLabel: UILabel! {
        didSet {
            let attributedString = NSMutableAttributedString(string: "Activated: Tuesday March 3 at 6:15pm")
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.withFace(.GothamBook, size: 13), range: NSRange(location: 0, length: 36))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: 36))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: JardenColor.teal, range: NSRange(location: 0, length: 10))
            lastActivatedLabel.attributedText = attributedString
        }
    }

    @IBOutlet weak var lastDeactivatedLabel: UILabel! {
        didSet {
            let attributedString = NSMutableAttributedString(string: "Deactivated: Tuesday March 3 at 6:18pm")
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.withFace(.GothamBook, size: 13), range: NSRange(location: 0, length: 38))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: 38))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: JardenColor.alarmSent, range: NSRange(location: 0, length: 12))
            lastDeactivatedLabel.attributedText = attributedString
        }
    }

    override func viewDidAppear(animated: Bool) {
        map.addAnnotation(PanicMapAnnotation(coordinate: userLocation,  tag: .User))
        map.addAnnotation(PanicMapAnnotation(coordinate: panicLocation, tag: .Panic))
        map.region = MKCoordinateRegion.centeredOn(userLocation, alsoContaining: panicLocation)
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true) {}
    }

    @IBAction func call911Tapped(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        let url = NSURL(string: "telprompt://911")!

        if app.canOpenURL(url) {
            app.openURL(url)
        } else {
            UIAlertController.stub(presentFrom: self, text: "Device can not handle telprompt:// URLs.")
        }
    }

    @IBAction func callUserTapped(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        let url = NSURL(string: "telprompt://6087295687")!

        if app.canOpenURL(url) {
            app.openURL(url)
        } else {
            UIAlertController.stub(presentFrom: self, text: "Device can not handle telprompt:// URLs.")
        }
    }

    @IBAction func textUserTapped(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        let url = NSURL(string: "sms://6087295687")!

        if app.canOpenURL(url) {
            app.openURL(url)
        } else {
            UIAlertController.stub(presentFrom: self, text: "Device can not handle sms:// URLs.")
        }
    }

    //MARK: MKMapViewDelegate conformance

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let kReuseIdentifier = "AnnotationReuseIdentifier"
        let annotationView: MKAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(kReuseIdentifier)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: kReuseIdentifier)
        annotationView.annotation = annotation

        if let taggedAnnotation = annotation as? PanicMapAnnotation {
            annotationView.image = UIImage(named: taggedAnnotation.tag == .User ? "SVG-map_teal_dot3" : "SVG-map_red_dot3")
        }
        return annotationView
    }

}
