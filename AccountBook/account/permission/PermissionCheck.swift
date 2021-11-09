//
//  PermissionCheck.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/08.
//

import Foundation
import CoreLocation

protocol LocationPermissionCallback{
    func getPermission(status: CLAuthorizationStatus)
    func getPoint(coordinate: CLLocationCoordinate2D)
}

class PermissionCheck: NSObject{
    private var locationCb: LocationPermissionCallback!
    
    init(locationCb: LocationPermissionCallback){
        self.locationCb = locationCb
    }
    
}

extension PermissionCheck: CLLocationManagerDelegate{
    
    func getLocationPermission(){
        if CLLocationManager.locationServicesEnabled() {
            locationCb.getPermission(status: CLLocationManager.authorizationStatus())
        }else{
            locationCb.getPermission(status: .notDetermined)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationCb.getPermission(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        locationCb.getPoint(coordinate: location.coordinate)
        
    }
    
}

enum PermissionState{
    case gotPermission
    case requestPermission
    case presentSetting
    case none
}
