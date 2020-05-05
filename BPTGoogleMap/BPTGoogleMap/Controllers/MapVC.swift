//
//  MapVC.swift
//  BPTGoogleMap
//
//  Created by Basith on 24/04/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Firebase
import GeoFire

class MapVC: UIViewController {
    
    let locationManager = CLLocationManager()
    var salonName_Info = "Salon Name"
    var mapLat = 0.0
    var mapLong = 0.0
    var coordinate : CLLocationCoordinate2D?
    var region : MKCoordinateRegion?
    var placemark: MKPlacemark?
    var mapItem : MKMapItem?
    var rootRef = Database.database().reference()
    var geoRef : GeoFire?
    var searchRadius : Double = 10.0
    @IBOutlet weak var mapViewUI: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        geoRef = GeoFire(firebaseRef: rootRef.child("user_locations"))
        loadMapRegion()
    }
    func loadMapRegion(){
        coordinate = CLLocationCoordinate2D(latitude: mapLat,longitude: mapLong)
        let camera = GMSCameraPosition.camera(withLatitude: mapLat, longitude: mapLong, zoom: 15.0)
        mapViewUI.camera = camera
        let marker = GMSMarker()
        marker.position = coordinate!
        marker.title = "Agaze"
        marker.snippet = "Technologies"
        marker.map = mapViewUI
    }
    func refrreshMarkers(){
        for positions in theAppModel.sharedInstance.neatbySalonesLocations! {
            let marker1 = GMSMarker()
            marker1.position = positions.coordinate
            marker1.title = "saloon"
            marker1.map = mapViewUI
        }
    }
    func findLocationNearby(){
        theAppModel.sharedInstance.neatbySalones = []
        theAppModel.sharedInstance.neatbySalonesLocations = []
        let myLocation = CLLocation(latitude: mapLat, longitude: mapLong)
        let query = geoRef!.query(at: myLocation, withRadius: searchRadius)
//        geoRef!.setLocation(CLLocation(latitude: 13.8718, longitude: 77.6022), forKey: "SaloneID_1")
        query.observe(.keyEntered, with: { key, location in
            theAppModel.sharedInstance.neatbySalones?.append(key)
            theAppModel.sharedInstance.neatbySalonesLocations?.append(location)
            print("Key: " + key + "is in search radius.")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { //wait for 2 sec
            query.removeAllObservers()
            if theAppModel.sharedInstance.neatbySalones!.isEmpty {
                self.searchRadius = self.searchRadius + 10
                print("Search radius increased \(self.searchRadius)")
                self.findLocationNearby()
            }else{
                self.refrreshMarkers()
                return
            }
        })
    }
}
extension MapVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        mapLat = locValue.latitude
        mapLong = locValue.longitude
        loadMapRegion()
        findLocationNearby()
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
