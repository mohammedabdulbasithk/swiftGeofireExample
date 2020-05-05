//
//  AppModel.swift
//  BPTGoogleMap
//
//  Created by Basith on 24/04/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import GeoFire


class theAppModel{
    
    static let sharedInstance = theAppModel()
    
//    let firtsvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstvc") as? FirstVC
    
    let appurl = AppUrl()
    let GOOGLE_MAP_APIKEY = ""
    var neatbySalones : [String]?
    var neatbySalonesLocations : [CLLocation]?
    
    func modelInit(){
        GMSServices.provideAPIKey(GOOGLE_MAP_APIKEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_MAP_APIKEY)
        neatbySalones = []
        neatbySalonesLocations = []
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
     
}

