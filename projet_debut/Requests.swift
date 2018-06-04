//
//  Request.swift
//  projet_debut
//
//  Created by Autre on 30/05/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation
class Requests {
    
    func post(parameters: [String: AnyObject], url: URL, finRequete: @escaping (_ response: [String: AnyObject], _ httpCode: Int?) -> Void) {
        print("Request.post : ")
        var requestResults :[String: AnyObject] = [String: AnyObject].init()
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            print("Request.post : Envoi JSON ok")
        } catch let error {
            print("Request.post : Envoi JSON pas ok")
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
            do {
                print("Request.post : Récupération JSON ok")
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]{
                
                    finRequete(json, httpCode)
                }
                else {
                    finRequete([String: AnyObject](), httpCode)

                }
            } catch let error {
                print("Request.post : Récupération JSON pas ok")
                finRequete([String: AnyObject](), httpCode)

            }
        }
        )
        task.resume()
        
        
        
    }
    
    
    
    
}
