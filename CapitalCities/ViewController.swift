//
//  ViewController.swift
//  CapitalCities
//
//  Created by Paulo Filho on 19/10/22.
//

import WebKit
import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var webView: WKWebView!
    var satelliteView = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2022 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called City of Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "map.fill"), style: .done, target: self, action: #selector(changeViewTapped))
        
        webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    @objc func changeViewTapped() {
        let ac = UIAlertController(title: "Map view", message: "Alternate map view?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self, weak ac] _ in
            if self?.satelliteView == false {
                self?.mapView.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: .realistic)
            } else {
                self?.mapView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .flat)
            }
            
            self?.satelliteView.toggle()
            ac?.dismiss(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        
        present(ac, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.markerTintColor = .cyan
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "View more", style: .default, handler: { [weak self] _ in
            guard placeName != nil, let capital = placeName?.components(separatedBy: " ").first else { return }
            
            let page = WikiPageController()
            page.capital = capital
            self?.navigationController?.pushViewController(page, animated: true)
        }))
        
        present(ac, animated: true)
    }
}

