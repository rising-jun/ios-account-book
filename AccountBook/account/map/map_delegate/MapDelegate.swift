//
//  MapDelegate.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/22.
//

import Foundation
import MapKit

class MapDelegate: NSObject{
    
}

extension MapDelegate: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(" s e l e c t e d")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        
        print("hi delegate")
        
        if let annotation = annotation as? PaidAnnotation {
            annotationView = PaidAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(PaidAnnotationView.self))
            //self.postAnnotationViews.append(annotationView as! PaidAnnotationView)
            print("it is paid annotation!")
        }
        return annotationView
    }
    
    private func setupPaiedAnnotation(for annotation: MKAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        let reuseIdentifier = NSStringFromClass(PaidAnnotationView.self)
        let postAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation) as? PaidAnnotationView
        postAnnotationView?.canShowCallout = false
        postAnnotationView?.clusteringIdentifier = NSStringFromClass(PaidAnnotationView.self)
        return postAnnotationView!
    }
    
}
