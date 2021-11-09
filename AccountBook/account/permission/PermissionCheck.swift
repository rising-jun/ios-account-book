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
    
}

enum PermissionState{
    case gotPermission
    case requestPermission
    case presentSetting
    case none
}
