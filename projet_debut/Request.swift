//
//  Request.swift
//  projet_debut
//
//  Created by Autre on 30/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation
class Requests {
    
    func post(parameters: [String: String], url: URL, finRequete: @escaping (_ response: [String: Any]) -> Void) {
        var requestResults :[String: Any] = [String: Any].init()
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse  {
                print(httpStatus.statusCode)
                requestResults["statut"] = httpStatus.statusCode
            } else {
                requestResults["statut"] = 0
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]{
                    let item: [String: Any] = [
                        "json": json
                    ]
                    requestResults["json"] = item
                }else {
                    requestResults["json"] = [String: Any].init()
                }
            } catch let error {
                requestResults["json"] = [String: Any].init()
                print("Erreur Json")
                print(error)
            }
            finRequete(requestResults)

        }
        )
        task.resume()
        
        
        
    }
    
    
    
    
}
