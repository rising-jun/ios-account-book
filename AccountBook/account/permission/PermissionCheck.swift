//
//  PermissionCheck.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/08.
//

import Foundation
import CoreLocation

protocol PermissionDelegate{
    func getPermission(status: CLAuthorizationStatus)
    func getPoint(coordinate: CLLocationCoordinate2D)
}

final class PermissionCheck: NSObject{
    private var delegate: PermissionDelegate?
    func setLocationDelegate(delegate: PermissionDelegate){
        self.delegate = delegate
    }
}

extension PermissionCheck{
    func getLocationPermission(){
        if CLLocationManager.locationServicesEnabled() {
            delegate?.getPermission(status: CLLocationManager.authorizationStatus())
        }else{
            delegate?.getPermission(status: .notDetermined)
        }
    }
}

extension PermissionCheck: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.getPermission(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        delegate?.getPoint(coordinate: location.coordinate)
    }
}

enum PermissionState{
    case gotPermission
    case requestPermission
    case presentSetting
    case none
}
