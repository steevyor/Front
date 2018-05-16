//
//  Json.swift
//  projet_debut
//
//  Created by Guillaume Messi on 07/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation

class Json{
    
    var lien :String
    var type :String // Variable qui contient le type de la donnée qui va etre parsée
    var values : [String:Any]
    
    init( new: String, kind: String) {
        self.lien = new
        self.type = kind
        self.values = ["":""];
    }
    
    var json:[String:AnyObject] = [:]
    
    func getJSON(){
        
        if (type == "user")
        {
        let url = URL(string: self.lien)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print("Une erreur est survenue");
                print("\(String(describing: error))")
            } else {
                do {
                    print(" ********** ********** LO-A-DING **********  ********** ");
                    self.json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:AnyObject]
                    
                    
                    let myData = self.json["data"]! //on sauvegarde le tout dans cette varialble
                    
                    let meCount = Int(self.json["data"]!.count) - 1//Nombre d'éléments
                    
                    for index in 0...meCount {
                        
                        let myLine = myData[index] as? [String: String]//On récupère puis affiche les éléments
                        print(myLine["userId"]!)
                        print(myLine["id"]!)
                        print(myLine["title"]!)
                        print(myLine["body"]!)
                        if let string = myLine["title"] as? String {
                            
                        }
                        self.values = myLine
                        
                    }
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        }
        
        if (type == "token")
        {
            let url = URL(string: self.lien)
            URLSession.shared.dataTask(with:url!) { (data, response, error) in
                if error != nil {
                    print("Une erreur est survenue");
                    print("\(String(describing: error))")
                } else {
                    do {
                        print(" ********** ********** LO-A-DING **********  ********** ");
                        self.json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:AnyObject]
                        
                        
                        let myData = self.json["data"]! //on sauvegarde le tout dans cette varialble
                        
                        let meCount = Int(self.json["data"]!.count) - 1//Nombre d'éléments
                        
                        for index in 0...meCount {
                            
                            let myLine = myData[index] as! [String:Any]//On récupère puis affiche les éléments
                            print(myLine["token"]!)
                            self.values = myLine
                            
                        }
                        
                        
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
                }.resume()
            
            
        
        }
        
        
    }
    
    func getValues() -> [String:Any] {
        return self.values
    }
}
