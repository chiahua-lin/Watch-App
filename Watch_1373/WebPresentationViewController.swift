//
//  WebPresentationViewController.swift
//  Watch_1373
//
//  Created by Robert Haworth on 4/13/15.
//  Copyright (c) 2015 Jarden Safety and Security. All rights reserved.
//

import UIKit
import WebKit

class WebPresentationViewController: UIViewController {

    let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(webView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["view":webView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["view":webView]))
        if let url = NSURL(string: "http://www.firstalert.com/") {
            webView.loadRequest(NSURLRequest(URL: url))
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true) {}
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
