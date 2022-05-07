//
//  MapDelegate.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/22.
//

import MapKit

final class MapDelegate: NSObject{
}

extension MapDelegate: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKAnnotationView.identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MKAnnotationView.identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
    }
    
    private func setupPaiedAnnotation(for annotation: MKAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let reuseIdentifier = NSStringFromClass(PaidAnnotationView.self)
        guard let postAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation) as? PaidAnnotationView else {
            return MKAnnotationView()
        }
        postAnnotationView.canShowCallout = false
        postAnnotationView.clusteringIdentifier = NSStringFromClass(PaidAnnotationView.self)
        return postAnnotationView
    }
    
}
extension MKAnnotationView{
    static let identifier = "Annotation"
}
