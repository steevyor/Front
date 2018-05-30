import UIKit
import SwiftKeychainWrapper
import MapKit


class LoginPageController: UIViewController
{

    
    
    @IBOutlet weak var loginPage: UIImageView!
    @IBOutlet weak var pseudo: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    var token: String = ""
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
    
    
    
    func connexion(login: String, password: String)
    {//, sortie: @escaping (_ statut: Int, _ token: String, _ pseudo: String) -> Void) {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let parameters = [
                "pseudo": "\(login)",
                "password": "\(password)"
            ]

            let url = URL(string: "https://eeba1d3c.ngrok.io/api/user/auth")!
            
            let r = Requests()
            r.post(parameters: parameters, url: url,
                                                 finRequete:{ response in
                                                    
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
                                                 )
        }
    
    
    //Probleme probleme
    /*func getFriendsPositions()//sortie: @escaping (_ statut: Int) -> Void)
    {
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters = [
            "pseudo": "\(self.user.getPseudo())",
            "token": "\(self.token)"
        ]
        
        let url = URL(string: "https://6adff20d.ngrok.io/api/user/friendPositions")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata
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
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                self.statut = httpStatus.statusCode
                print("Positions", self.statut)
            }
                
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: [[]]) as? [String: AnyObject]{
                    print("json ok")
                    for i in 1...json.count {
                        var f: Friend = Friend.init()
                        print(json)
                        if let s = json[i]["pseudo"] as? [String:Any] {
                            print("pseudo ok", s)
                            f.setPseudo(s: s)
                            //sortie(self.statut)
                        }
                        if let coord = json[i]["coordinates"] as? [[String: Any]] {
                            print("coordonnées ok", coord)
                            f.setCoordinates(latitude: coord["xCoordinate"] as! CLLocationDegrees, longitude: coord["yCoordinate"] as! CLLocationDegrees)
                            //sortie(self.statut)
                        }
                        self.friendsToDisplay.append(f)
                    }
                } else {
                    //sortie(self.statut)
                }
                print()
            } catch let error {
                print("erreur json")
                print(error.localizedDescription)
                //sortie(self.statut)
            }
        })
        task.resume()
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false


        
    }*/
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





