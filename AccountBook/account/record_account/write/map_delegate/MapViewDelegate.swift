//
//  MapViewDelegate.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/10.
//

import Foundation
import MapKit

protocol MapDraggedDelegate{
    func draggedPoint(coordi: CLLocationCoordinate2D)
}

final class WriteMapViewDelegate: NSObject{
    private var delegate: MapDraggedDelegate?
    
    func setMapDraggedDelegate(from delegate: MapDraggedDelegate){
        self.delegate = delegate
    }
}

extension WriteMapViewDelegate: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKUserLocation else { return MKAnnotationView() }
        let reuseId = "pin"
        
        guard let pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView else {
            var pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            return pinAnnotationView
        }
        pinAnnotationView.annotation = annotation
        return pinAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.ending {
            if let droppedAt = view.annotation?.coordinate{
                delegate?.draggedPoint(coordi: droppedAt)
            }
        }
    }
}
