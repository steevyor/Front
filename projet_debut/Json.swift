//
//  Json.swift
//  projet_debut
//
//  Created by Guillaume Messi on 07/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation

class Json{
    
    var json:[String:AnyObject] = [:]
    
    
    let lien = "https://jsonplaceholder.typicode.com/posts/1"
    
    func getJSON(){
        
        let url = URL(string: lien)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print("probleme mgl");
                print("\(String(describing: error))")
            } else {
                do {
                    print(" ********** ********** LO-A-DING **********  ********** ");
                    self.json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:AnyObject]
                    
                    
                    let myData = self.json["data"]! //on sauvegarde le tout dans cette varialble
                    
                    let meCount = Int(self.json["data"]!.count) - 1//Nomnre d'éléments
                    
                    for index in 0...meCount {
                        
                        let myLine = myData[index] as! [String:Any]//On récupère puis affiche les éléments
                        print(myLine["userId"]!)
                        print(myLine["id"]!)
                        print(myLine["title"]!)
                        print(myLine["body"]!)
                        
                    }
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
        
    }
    
}
