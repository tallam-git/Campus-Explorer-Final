//
//  NavigationVC.swift
//  CampusExplore
//
//  Created by Vishnu on 10/11/23.
//


import UIKit
import MapKit

class NavigationVC: UIViewController {

    @IBOutlet weak var dest: UITextField!
    @IBOutlet weak var source: UITextField!
    @IBOutlet weak var map: MKMapView!
    var selected = "Pick"
    
    var fromCordinate : CLLocationCoordinate2D?
    var toCordinate : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        map.mapType = .standard
    }
    @IBAction func onFrom(_ sender: Any) {
        self.selected = "Pick"
        let mapKit = MapKitSearchViewController(delegate: self)
        mapKit.modalPresentationStyle = .fullScreen
        present(mapKit, animated: true, completion: nil)
    }
    @IBAction func onTo(_ sender: Any) {
        self.selected = "Drop"
        let mapKit = MapKitSearchViewController(delegate: self)
        mapKit.modalPresentationStyle = .fullScreen
        present(mapKit, animated: true, completion: nil)
    }
  
    
    @IBAction func onNavigate(_ sender: Any) {
        
        
        if(self.fromCordinate == nil) {
            showAlerOnTop(message: "Please select starting point")
            return
        }
        
        if(self.toCordinate == nil) {
            showAlerOnTop(message: "Please select end point")
            return
        }
         
        
        guard let fromCoordinate = fromCordinate, let toCoordinate = toCordinate else {
                showAlerOnTop(message: "Invalid coordinates")
                return
            }

            let sourcePlacemark = MKPlacemark(coordinate: fromCoordinate)
            let destinationPlacemark = MKPlacemark(coordinate: toCoordinate)

            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

            let options: [String: Any] = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
                MKLaunchOptionsShowsTrafficKey: true
            ]

            MKMapItem.openMaps(with: [sourceMapItem, destinationMapItem], launchOptions: options)
        
    }

}

extension NavigationVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Customize the appearance of the polyline
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }
}



extension NavigationVC: MapKitSearchDelegate {
    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, mapItem: MKMapItem) {
    }
    
    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, searchReturnedOneItem mapItem: MKMapItem) {
    }

    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedListItem mapItem: MKMapItem) {
    }

    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedGeocodeItem mapItem: MKMapItem) {
    }

    func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedAnnotationFromMap mapItem: MKMapItem) {
        print(mapItem.placemark.address)
        
        mapKitSearchViewController.dismiss(animated: true)
        self.setAddress(mapItem: mapItem)
    }
    
    
    func setAddress(mapItem: MKMapItem) {
        
        if(selected == "Pick") {
            self.fromCordinate =  mapItem.placemark.coordinate
            self.source.text = mapItem.placemark.mkPlacemark!.description.removeCoordinates()
        }else {
            self.toCordinate =  mapItem.placemark.coordinate
            self.dest.text = mapItem.placemark.mkPlacemark!.description.removeCoordinates()
        }
        
        if(self.fromCordinate != nil  && self.toCordinate != nil ) {
            
            self.drowPath()
        }
        
    }
    
}


extension NavigationVC {
    
    func drowPath() {
        guard let fromCoordinate = fromCordinate, let toCoordinate = toCordinate else {
            return
        }
        
        let sourcePlacemark = MKPlacemark(coordinate: fromCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: toCoordinate)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile // You can change this to .walking or .transit if needed
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            guard let route = response?.routes.first else {
                if let error = error {
                    print("Error getting directions: \(error.localizedDescription)")
                }
                return
            }
            
            // Remove previous overlays before adding a new one
            self.map.removeOverlays(self.map.overlays)
            
            // Add the new route overlay to the map
            self.map.addOverlay(route.polyline, level: .aboveRoads)
            
            // Set the visible region of the map to show the entire route
            let rect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
}
