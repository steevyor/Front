//
//  Pin.swift
//  projet_debut
//
//  Created by Autre on 30/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation
import MapKit



class Pin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    let image:UIImage = UIImage("rabbit-25")
    
    
    init(c: CLLocationCoordinate2D ) {
        self.coordinate = c
    }
    
}

class AnnotationView: MKAnnotationView
{
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point)
                if isInside
                {
                    break
                }
            }
        }
        return isInside
    }
}
