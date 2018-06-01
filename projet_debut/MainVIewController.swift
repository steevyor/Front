//
//  MainVIewController.swift
//  projet_debut
//
//  Created by Guillaume Messi on 01/06/2018.
//  Copyright © 2018 m2sar. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController{
    
    var statut: Int = 0
    var friendsToDisplay: FriendList = FriendList.init()
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if let pseudo = UserDefaults.standard.string(forKey: "pseudo"),
            let token  = UserDefaults.standard.string(forKey: "taken"){
            getFriendsPositions(pseudo: pseudo, token: token)
            let value = storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapViewController
            print("ko")
            self.present(value, animated: true)
        }else{
            let value = storyboard?.instantiateViewController(withIdentifier: "LoginPage") as! LoginPageController
            print("ok")
            self.present(value, animated: true)
            
        }
        
    }
    
    func getFriendsPositions(pseudo: String, token:String)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters = [
            "pseudo": "\(pseudo)",
            "tokenKey": "\(token)"
            ] as [String : AnyObject]
        
        let url = URL(string: "https://9b638f40.ngrok.io/api/user/friendPositions")!
        
        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                
                self.statut = statut!
                if let tab = response["friends"] as? [AnyObject] {
                    print("Reponse getPositions", tab)
                    for i in 0...tab.count-1 {
                        var f: Friend = Friend.init()
                        if let amis = tab[i] as? [String: AnyObject] {
                            print("amis ok", amis)
                            f.setPseudo(s: amis["pseudo"] as! String )
                            if let coord = amis["coordinate"] as? [String: AnyObject] {
                                f.setCoordinates(latitude: coord["xCoordinate"] as! Double, longitude: coord["yCoordinate"] as! Double)
                            }
                        }
                        self.friendsToDisplay.addFriend(f: f)
                    }
                }
                
                if self.statut != 200 {
                    DispatchQueue.main.async(execute: {
                        let monAlerte = UIAlertController(title: "☔️", message: "Une erreur s'est produite dans le chargement de la position des amis", preferredStyle: UIAlertControllerStyle.alert)
                        monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                        self.present(monAlerte, animated: true, completion: nil)
                    })
                    
                }
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "SegueLogin", sender: nil)
                })
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "SegueLogin", sender: nil)
                })
        }
        )
        
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "SegueLogin" {
            for i in 0...self.friendsToDisplay.getList().count-1 {
                print("dans prepare", friendsToDisplay.getList()[i].getPseudo(), friendsToDisplay.getList()[i].getCoordinates().latitude, friendsToDisplay[i].getCoordinates().longitude )
            }
            let map =  (segue.destination as! NavigationController).viewControllers.first as! MapViewController
            map.friendsToDisplay = self.friendsToDisplay
            map.user = User.init(u: self.user)
        }
    }
    */

    
}
