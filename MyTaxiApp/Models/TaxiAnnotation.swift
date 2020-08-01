//
//  TaxiAnnotation.swift
//  mytaxi
//
//  Created by Kalpesh Talkar on 03/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

import MapKit

class TaxiAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image = #imageLiteral(resourceName: "taxi_pin")
    var taxi: Taxi? = nil {
        didSet {
            rotateImage()
        }
    }
    var rotatedImage = #imageLiteral(resourceName: "taxi_pin")
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    private func rotateImage() {
        if taxi != nil {
            let rotationAngle: CGFloat = CGFloat(taxi!.heading * .pi / 180)
            var coreImage = image.ciImage
            if coreImage == nil {
                coreImage = CIImage(cgImage: image.cgImage!)
            }
            //coreImage = coreImage?.transformed(by: CGAffineTransform(rotationAngle: rotationAngle))
            //rotatedImage = UIImage(ciImage: coreImage!)
            
            UIGraphicsBeginImageContext(image.size)
            let context = UIGraphicsGetCurrentContext()
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            let orignalRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            context?.concatenate(CGAffineTransform(rotationAngle: rotationAngle))
            context?.draw(image.cgImage!, in: orignalRect)
            
            rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
        }
    }
    
}
