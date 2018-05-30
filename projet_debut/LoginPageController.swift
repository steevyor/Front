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
            
            let parameters = [
                "pseudo": "\(login)",
                "password": "\(password)"
            ]

        let url = URL(string: "https://eeba1d3c.ngrok.io/api/user/auth")!
        
        let r = Requests()
        r.post(parameters: parameters as [String : AnyObject], url: url,
                                             finRequete:{ response in
                                                
                                                    self.statut = response["statut"] as! Int
                                                print(response)
                                                    let preJson: [String:AnyObject] = response["json"] as! [String : AnyObject]
                                                    let json: [String:AnyObject] = preJson["json"] as! [String : AnyObject]
                                                    print(json)
                                                if let tab: [String:AnyObject] = json["user"] as? [String: AnyObject] {
                                                    print("tab:", tab["pseudo"])
                                                    self.user.setPseudo(s: tab["pseudo"] as! String)
                                                    print(self.user.getPseudo()
                                                    )
                                                }
                                                
                                                if let tab: [String:AnyObject] = json["token"] as? [String: AnyObject] {
                                                    print("tab:", tab["key"])
                                                    self.user.setToken(s: tab["key"] as! String)
                                                        print(self.user.getToken())
                                                    }else {
                                                        print(self.statut)
                                                    }
                                                
                                                    if self.statut == 200 {
                                                        DispatchQueue.main.async(execute: {
                                                            print("token avant friend : " + self.user.getToken())
                                                            self.getFriendsPositions()
                                                            self.performSegue(withIdentifier: "SegueLogin", sender: nil)
                                                        })
                                                    } else if self.statut == 401 || self.statut == 400 {
                                                        DispatchQueue.main.async(execute: {
                                                            let monAlerte = UIAlertController(title: "☔️", message: "Mot de passe ou pseudo incorrect", preferredStyle: UIAlertControllerStyle.alert)
                                                            monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                                                            self.present(monAlerte, animated: true, completion: nil)
                                                        })
                                                    } else {
                                                        DispatchQueue.main.async(execute: {
                                                            let monAlerte = UIAlertController(title: "☔️", message: "Une erreur s'est produite", preferredStyle: UIAlertControllerStyle.alert)
                                                            monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                                                            self.present(monAlerte, animated: true, completion: nil)
                                                        })
                                                    
                                                        self.statut = response["statut"] as! Int
                                                        let json: [String:Any] = response["json"] as! [String : Any]
                                                    
                                                        if let tab = json["user"] as? [String: AnyObject] {
                                                            self.user.setPseudo(s: tab["pseudo"] as! String)
                                                        }
                                                    
                                                        if let tab = json["token"] as? [String: AnyObject] {
                                                            self.user.setToken(s: tab["key"] as! String)
                                                            print(self.statut)
                                                        }else {
                                                            print(self.statut)
                                                        }
                                                    
                                                        if self.statut == 200 {
                                                            DispatchQueue.main.async(execute: {
                                                                //self.getFriendsPositions()
                                                                self.performSegue(withIdentifier: "SegueLogin", sender: nil)
                                                            })
                                                        } else if self.statut == 401 || self.statut == 401 {
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
        })
    }
    
    
    func getFriendsPositions()//sortie: @escaping (_ statut: Int) -> Void)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters = [
            "pseudo": "\(self.user.getPseudo())",
            "token": [
                "key":"\(self.user.getToken())"
                ]
        ] as [String : AnyObject]
        
        let url = URL(string: "https://6adff20d.ngrok.io/api/user/friendPositions")!
        
        
        let r = Requests()
        r.post(parameters: parameters as! [String : AnyObject], url: url,
               finRequete:{ response in
                
                self.statut = response["statut"] as! Int
                let json: [AnyObject] = response["json"] as! [AnyObject]
                
                for i in 0...json.count-1 {
                    var f: Friend = Friend.init()
                    if let amis = json[i] as? [String: AnyObject] {
                        print("amis ok", amis)
                        f.setPseudo(s: amis["pseudo"] as! String )
                        if let coord = amis["coordinate"] as? [String: AnyObject] {
                            f.setCoordinates(latitude: coord["xCoordinate"] as! CLLocationDegrees, longitude: coord["yCoordinate"] as! CLLocationDegrees)
                        }
                    }
                    self.friendsToDisplay.append(f)
                }
                
                if self.statut != 200 {
                    DispatchQueue.main.async(execute: {
                        let monAlerte = UIAlertController(title: "☔️", message: "Une erreur s'est produite dans le chargement de la position des amis", preferredStyle: UIAlertControllerStyle.alert)
                        monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                        self.present(monAlerte, animated: true, completion: nil)
                    })
                    
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
            let map =  (segue.destination as! NavigationController).viewControllers.first as! MapViewController
            map.friendSegue = self.friendsToDisplay
            map.user = User.init(u: self.user)
            print("prepare")
            print("Pseudo : " + self.user.getPseudo() + " token :" + self.user.getToken())
        }
    }

}





