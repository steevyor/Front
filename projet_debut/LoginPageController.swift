import UIKit
import SwiftKeychainWrapper
import MapKit
let ngrok = "fd4b2c2c"

class LoginPageController: UIViewController
{

    
    
    @IBOutlet weak var loginPage: UIImageView!
    @IBOutlet weak var pseudo: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    var user: User = User.init()
    var statut: Int = 0
    
    
    //Les amis récupérés à afficher sur la map
    var friendsToDisplay = FriendList()
    
    

    
    override func viewDidLoad(){
        self.friendsToDisplay.addList(tab:
            [Friend.init(pseudo: "A", coord: CLLocationCoordinate2D(latitude: 20.10, longitude: 10.12)),
             Friend.init(pseudo: "B", coord: CLLocationCoordinate2D(latitude: 83.10, longitude: 15.19)),
             Friend.init(pseudo: "C", coord: CLLocationCoordinate2D(latitude: 04.15, longitude: 17.11))]
        )
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

        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/auth")!
        print("LoginController.connexion : URL : \(url)")
        
        let r = Requests()
        r.post(parameters: parameters as [String : AnyObject], url: url,
                                             finRequete:{ response, statut in
                                                print("LoginController.connexion : statut = \(statut)")
                                                self.statut = statut as! Int
                
                                                if let tab: [String:AnyObject] = response["token"] as? [String: AnyObject] {
                                                    print("LoginController.connexion : Récupération du json")
                                                    print("LoginController.connexion : Pseudo: \(tab["pseudo"])")
                                                    print("LoginController.connexion : Token: \(tab["token"])")
                                                    self.user.setPseudo(s: tab["pseudo"] as! String)
                                                    self.user.setToken(s: tab["key"] as! String)
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
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/friends")!
        print("LoginController.getFriendsPosition : URL : \(url)")

        
        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("LoginController.getFriendsPosition : statut = \(statut)")
                self.statut = statut as! Int
                
                if let tab = response["friends"] as? [AnyObject] {
                    print("LoginController.getFriendsPosition : Récupération du json")
                    for i in 0..<tab.count {
                        var f: Friend = Friend.init()
                        if let amis = tab[i] as? [String: AnyObject] {
                            print("amis ok", amis)
                            f.setPseudo(s: amis["pseudo"] as! String )
                            if let coord = amis["coordinate"] as? [String: AnyObject] {
                                f.setCoordinates(latitude: coord["xCoordinate"] as! Double, longitude: coord["yCoordinate"] as! Double)
                                self.friendsToDisplay.addFriend(f: f)
                            }
                        }
                    }
                }
                
                if self.statut != 200 {
                    DispatchQueue.main.async(execute: {
                        let monAlerte = UIAlertController(title: "☔️", message: "Une erreur s'est produite dans le chargement de la position des amis", preferredStyle: UIAlertControllerStyle.alert)
                        monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                        self.present(monAlerte, animated: true, completion: nil)
                    })
                    
                } else {
                    DispatchQueue.main.async(execute: {
                        self.performSegue(withIdentifier: "SegueLogin", sender: nil)
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
            print("LoginController.Prepare")
            let map =  (segue.destination as! NavigationController).viewControllers.first as! MapViewController
            map.friendsToDisplay = self.friendsToDisplay
            map.user = User.init(u: self.user)
        }
    }

}





