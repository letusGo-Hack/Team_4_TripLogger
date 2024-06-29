//
//  Articl.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import UIKit
import SwiftData

//@Model
final class Article {
    
    var latitude: Double
    var longitude: Double
    
    var imageData: Data?
    var content: String?
    
    init(latitude: Double, longitude: Double, image: UIImage? = nil, content: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.imageData = image?.pngData()
        self.content = content
    }
}
