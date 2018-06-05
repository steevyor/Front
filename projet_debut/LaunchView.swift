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
        super.viewDidLoad()
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
            print("Dans le cas ou les valeurs sont ok")
            let r = Requests()
            r.getFriendPositions(pseudo: first!, token: second!, chargementAmis:{ friends in
                
                
                    if friends.getList().count == 0 {
                        DispatchQueue.main.async(execute: {
                            print("Dans le cas ou la connexion est pas ok")
                            self.activity.stopAnimating()
                            self.performSegue(withIdentifier: "ToLogin", sender: self)
                        })

                    } else {
                        DispatchQueue.main.async(execute: {
                            self.user.addContacts(f: friends)
                            print("Dans le cas ou la connexion est ok")
                            self.user.setPseudo(s: first!)
                            self.user.setToken(s: second!)
                            self.activity.stopAnimating()
                            self.performSegue(withIdentifier: "ToMap", sender: self)
                            
                        })

                        
                    }
                
            })

        }else{
            print("Dans le cas ou les valeurs sont pas ok")
            self.activity.stopAnimating()
            self.performSegue(withIdentifier: "ToLogin", sender: self)
        }
        
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
