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
        if annotation is MKUserLocation { return nil }

        guard let pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKAnnotationView.reuseId) else {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MKAnnotationView.reuseId)
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
extension MKAnnotationView{
    static let reuseId = "pin"
}
