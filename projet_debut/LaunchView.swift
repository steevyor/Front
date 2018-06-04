//
//  LaunchView.swift
//  projet_debut
//
//  Created by Guillaume Messi on 04/06/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation
import UIKit

class LaunchView: UIViewController {
    
    private var user: User = User.init()
    private var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        self.viewDidLoad()
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        
        // Position Activity Indicator in the center of the main view
        self.activity.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        self.activity.hidesWhenStopped = false
        
        // Start Activity Indicator
        self.activity.startAnimating()
        
        // Call stopAnimating() when need to stop activity indicator
        //myActivityIndicator.stopAnimating()
        
        
        view.addSubview(self.activity)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let change = UserDefaults.standard
        let first = change.string(forKey: "Bruce")
        let second = change.string(forKey: "taken")
        if (first != nil) && (second != nil){
            user.setPseudo(s: first!)
            user.setToken(s: second!)
            getFriendsPositions()
        }else{

            self.activity.stopAnimating()
            self.performSegue(withIdentifier: "ToLogin", sender: self)
        }
        
    }
    
    func getFriendsPositions()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters = [
            "pseudo": "\(self.user.getPseudo())",
            "tokenKey": "\(self.user.getToken())"
            ] as [String : AnyObject]
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/friends")!
        print("LoginController.getFriendsPosition : URL : \(url)")
        
        
        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("LoginController.getFriendsPosition : statut = \(statut)")
                
                if let tab = response["friends"] as? [AnyObject] {
                    print("LoginController.getFriendsPosition : Récupération du json")
                    for i in 0..<tab.count {
                        var f: Friend = Friend.init()
                        if let amis = tab[i] as? [String: AnyObject] {
                            print("amis ok", amis)
                            f.setPseudo(s: amis["pseudo"] as! String )
                            if let coord = amis["coordinate"] as? [String: AnyObject] {
                                f.setCoordinates(latitude: coord["xCoordinate"] as! Double, longitude: coord["yCoordinate"] as! Double)
                                self.user.addContact(f: f)
                            }
                        }
                    }
                }
                
                if statut == 200 {
                    DispatchQueue.main.async(execute: {
                        self.activity.stopAnimating()
                        self.performSegue(withIdentifier: "ToMap", sender: self)
                        
                    })
                    
                }else{
                    self.message(display: "Veuillez redemmarer l'application et activer une connexion reseau", emoji: "", dissmiss: "☠︎")
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
        }
        )
    }
    
    //Envoyer à la vue suivante les amis récupérés et le token
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ToMap" {
            print("LaunchView.prepare")
            let map =  (segue.destination as! NavigationController).viewControllers.first as! MapViewController
            map.user = User.init(u: self.user)
            
        }
    }
    
    func message(display: String, emoji: String, dissmiss: String) -> Void
    {
        let monAlerte = UIAlertController(title: emoji, message:display, preferredStyle: UIAlertControllerStyle.alert)
        monAlerte.addAction(UIAlertAction(title: dissmiss, style: UIAlertActionStyle.default,handler: nil))
        self.present(monAlerte, animated: true, completion: nil)
        
    }

}
