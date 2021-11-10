//
//  MapViewDelegate.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/10.
//

import Foundation
import MapKit

class MapViewDelegate: NSObject{
    
    
}

extension MapViewDelegate: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
                return nil
            }
        
            let reuseId = "pin"
        
        var pav: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            if pav == nil {
                pav = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pav?.isDraggable = true
                pav?.canShowCallout = true
            } else {
                pav?.annotation = annotation
            }

            return pav
    }
}
