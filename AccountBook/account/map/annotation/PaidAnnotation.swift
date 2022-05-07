//
//  PaidAnnotation.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/22.
//

import MapKit

final class PaidAnnotation: NSObject, Decodable, MKAnnotation{
    
    init(index: Int, latitude: Double?, longitude: Double?, bookInfo: BookInfo) {
        self.index = index
        self.latitude = latitude ?? 0.0
        self.longitude = longitude ?? 0.0
        self.bookInfo = bookInfo
    }
    
    private var bookInfo: BookInfo
    private var index: Int
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            // For most uses, `coordinate` can be a standard property declaration without the customized getter and setter shown here.
            // The custom getter and setter are needed in this case because of how it loads data from the `Decodable` protocol.
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
}

