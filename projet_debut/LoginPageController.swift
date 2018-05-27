import UIKit
import SwiftKeychainWrapper
import MapKit


class LoginPageController: UIViewController
{

    
    
    @IBOutlet weak var loginPage: UIImageView!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    var token: String = ""
    var user: User = User.init()
    var statut: Int = 0
    
    
    //Les amis récupérés à afficher sur la map
    let friendsToDisplay = [Friend.init(pseudo: "A", coord: CLLocationCoordinate2D(latitude: 20.10, longitude: 10.12)),
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
        let login = self.mail.text
        let password = self.mdp.text
        
        if (login?.isEmpty)! || (password?.isEmpty)!
        {
            let monAlerte = UIAlertController(title: "☔️", message: "Veuillez renseigner tous les champs", preferredStyle: UIAlertControllerStyle.alert)
            monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
            self.present(monAlerte, animated: true, completion: nil)
            
        }
        else
        {
            self.connexion(login: login! ,password: password!)
            print(self.statut)
            
            if self.statut == 200 {
                self.getFriends()
            } else if self.statut == 401{
                let monAlerte = UIAlertController(title: "☔️", message: "Pseudo ou mot de passe incorrect", preferredStyle: UIAlertControllerStyle.alert)
                monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                self.present(monAlerte, animated: true, completion: nil)
                
            } else if self.statut == 404 {
                let monAlerte = UIAlertController(title: "☔️", message: "Pseudo inconnu", preferredStyle: UIAlertControllerStyle.alert)
                monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                self.present(monAlerte, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    func connexion(login: String, password: String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters = [
            "pseudo": "\(login)",
            "password": "\(password)"
        ]

        let url = URL(string: "https://90f349a9.ngrok.io/api/user/auth")!
            
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
            print(self.statut)
        }
            
        do {
        //create json object from data
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray{
                self.user.setPseudo(s: json[0] as! String)
                if let tab = json[1] as? [String: Any] {
                    self.user.setToken(s: tab["key"] as! String)
                }
            }
            print()
        } catch let error {
            print(error.localizedDescription)
        }
        })
    task.resume()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    
    /*
    func getFriends()
    {
        let feedURL = "localhost:8080/api/user/positions"
        var request = URLRequest(url: URL(string: feedURL)!)
        let session = URLSession.shared.dataTask(with: request ,completionHandler:
        { (data, response, error) in
            if let jsonData = data ,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData , options: .mutableContainers)) as? NSDictionary ,
                let login = feed.value(forKeyPath: "feed.entry.im:pseudo.label") as? String ,
                let longitude = feed.value(forKeyPath: "feed.entry.im:longitude.label") as? String ,
                let latitude = feed.value(forKeyPath: "feed.entry.im:latitude.label") as? String {
                var f: Friend = Friend.init(pseudo: login)
                f.setCoordinates(latitude: longitude as! CLLocationDegrees, longitude: latitude as! CLLocationDegrees)
            }
        })
        
        //créer un tableau de friends pour l'afficher
        session.resume()
    }
     */
    
    func getFriends()
    {
        let url = URL(string: "https://90f349a9.ngrok.io/api/user/auth")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET" //set http method as POST
        
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
                print(self.statut)
            }
                
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray{
                    var f: Friend = Friend.init(pseudo: json[0] as! String)
                    if let latitude = json[1] as? [String: Any], let longitude = json[2] as? [String: Any] {
                        f.setCoordinates(latitude: longitude as! CLLocationDegrees, longitude: latitude as! CLLocationDegrees)
                    }
                }
                print()
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()

        
    }
    
    
    //Envoyer à la vue suivante les amis récupérés et le token
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue" {
            let map =  (segue.destination as! NavigationController).viewControllers.first as! MapViewController
            map.friendSegue = self.friendsToDisplay
            map.user = User.init(u: self.user)
            print("prepare")
            print("Pseudo : " + self.user.getPseudo() + " token :" + self.user.getToken())
        }
    }

}





