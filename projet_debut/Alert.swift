//
//  Alert.swift
//  projet_debut
//
//  Created by Autre on 02/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import UIKit
class Alert {
    
    func createAlert(msg: String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
    
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
    
        alert.present(alert, animated: true, completion: nil)
    }
}
