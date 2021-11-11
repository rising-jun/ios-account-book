//
//  MapViewDelegate.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/10.
//

import Foundation
import MapKit

protocol MapProtocol{
    func draggedPoint(coordi: CLLocationCoordinate2D)
}

class MapViewDelegate: NSObject{
    private var mapProtocol: MapProtocol!
    
    init(mapProtocol: MapProtocol){
        self.mapProtocol = mapProtocol
    }
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.ending {
            if let droppedAt = view.annotation?.coordinate{
                mapProtocol.draggedPoint(coordi: droppedAt)
            }
        }
    }
    
}
