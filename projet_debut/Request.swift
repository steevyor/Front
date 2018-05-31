//
//  Request.swift
//  projet_debut
//
//  Created by Autre on 30/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation
class Requests {
    
    func post(parameters: [String: AnyObject], url: URL, finRequete: @escaping (_ response: [String: Any], _ httpCode: Int?) -> Void) {
        var requestResults :[String: AnyObject] = [String: AnyObject].init()
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            print(request.httpBody)
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
            var httpCode = (response as? HTTPURLResponse)?.statusCode
            
            print(data)
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]{
                
                    finRequete(json, httpCode)
                }
            } catch let error {
                print("Erreur Json")
                print(error)
            }
            

        }
        )
        task.resume()
        
        
        
    }
    
    
    
    
}
