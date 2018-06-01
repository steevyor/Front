import UIKit
import SwiftKeychainWrapper
import MapKit


class LoginPageController: UIViewController
{

    
    
    @IBOutlet weak var loginPage: UIImageView!
    @IBOutlet weak var pseudo: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    //var token: String = ""
    var user: User = User.init()
    var statut: Int = 0
    
    
    //Les amis récupérés à afficher sur la map
    var friendsToDisplay = [Friend.init(pseudo: "A", coord: CLLocationCoordinate2D(latitude: 20.10, longitude: 10.12)),
                            Friend.init(pseudo: "B", coord: CLLocationCoordinate2D(latitude: 83.10, longitude: 15.19)),
                            Friend.init(pseudo: "C", coord: CLLocationCoordinate2D(latitude: 04.15, longitude: 17.11))]
    

    
    override func viewDidLoad(){
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func connexion(_ sender: Any)
    
    {
        let login = self.pseudo.text
        let password = self.mdp.text
        
        if (login?.isEmpty)! || (password?.isEmpty)!
        {
            self.message(display: "Veuillez renseigner tous les champs", emoji: "☔️", dissmiss: "Annuler")
            
        }
        else
        {
            self.connexion(login: login!, password: password!)
        }
    }
    
    
    
    func connexion(login: String, password: String){
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let storage = UserDefaults.standard
            storage.set(login, forKey: "pseudo")
            storage.synchronize()
        
            let parameters = [
                "pseudo": "\(login)",
                "password": "\(password)"
            ]

        let url = URL(string: "https://9b638f40.ngrok.io/api/user/auth")!
        
        let r = Requests()
        r.post(parameters: parameters as [String : AnyObject], url: url,
                                             finRequete:{ response, statut in
                                                
                                                self.statut = statut as! Int
                                                
                                                print("Reponse auth", response)
                                                if let tab: [String:AnyObject] = response["token"] as? [String: AnyObject] {
                                                    print("tab:", tab["pseudo"])
                                                    self.user.setPseudo(s: tab["pseudo"] as! String)
                                                    print(self.user.getPseudo())
                                                    print("tab:", tab["key"])
                                                    self.user.setToken(s: tab["key"] as! String)
                                                        print(self.user.getToken())
                                                }else {
                                                        print(self.statut)
                                                }
                                                if self.statut == 200 {
                                                    self.getFriendsPositions()
                                                        
                                                } else if self.statut == 401 {
                                                    DispatchQueue.main.async(execute: {
                                                            self.message(display: "Mot de passe ou pseudo incorrect", emoji: "☔️", dissmiss: "Annuler")
                                                        })
                                                } else {
                                                        DispatchQueue.main.async(execute: {
                                                            self.message(display: "Une erreur s'est produite", emoji: "☔️", dissmiss: "Annuler")
                                                        })
                                                        
                                                }
                                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                                }
        )
    }
    
    
    func getFriendsPositions()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters = [
            "pseudo": "\(self.user.getPseudo())",
            "tokenKey": "\(self.user.getToken())"
        ] as [String : AnyObject]
        
        let url = URL(string: "https://9b638f40.ngrok.io/api/user/friendPositions")!
        
        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                
                self.statut = statut as! Int
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
                        self.friendsToDisplay.append(f)
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
    
    
    //Chargée d'afficher les messages à l'utilisateur
    func message(display: String, emoji: String, dissmiss: String) -> Void
    {
        let monAlerte = UIAlertController(title: emoji, message:display, preferredStyle: UIAlertControllerStyle.alert)
        monAlerte.addAction(UIAlertAction(title: dissmiss, style: UIAlertActionStyle.default,handler: nil))
        self.present(monAlerte, animated: true, completion: nil)
        
    }
    
    
    //Envoyer à la vue suivante les amis récupérés et le token
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "SegueLogin" {
            for i in 0...friendsToDisplay.count-1 {
                print("dans prepare", friendsToDisplay[i].getPseudo(), friendsToDisplay[i].getCoordinates().latitude, friendsToDisplay[i].getCoordinates().longitude )
            }
            let map =  (segue.destination as! NavigationController).viewControllers.first as! MapViewController
            map.friendSegue = self.friendsToDisplay
            map.user = User.init(u: self.user)
            print("prepare")
            print("Pseudo : " + self.user.getPseudo() + " token :" + self.user.getToken())
        }
    }

}





