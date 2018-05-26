import UIKit
import SwiftKeychainWrapper
import MapKit


class LoginPageController: UIViewController
{

    
    
    @IBOutlet weak var loginPage: UIImageView!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    var user: User = User.init()
    
    
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
            self.connexion(login: login!, password: password!)
        }
    }
    
    
    
    func connexion(login: String, password: String){
        let parameters = [
            "pseudo": "\(login)",
            "password": "\(password)"
        ]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = URL(string: "https://90f349a9.ngrok.io/api/user/auth")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let res = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.user.setPseudo(s: (res["pseudo"]! as? String)!)
                    self.user.setEmail(s: (res["email"]! as? String)!)
                    self.user.setToken(s: (res["token"]! as? String)!) 
                    
                    
                    //self.user.setCoord(c: CLLocationCoordinate2D.init(latitude: res["coord"]["xCoordinate"], longitude: res["coord"]["yCoordinate"]))
                    
                }
            } catch let error {
                print(error.localizedDescription)            }
        })
        task.resume()
        
        
    }
    
    func getFriendsPosition()
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
    
    
    
    
    //Envoyer à la vue suivante les amis récupérés et le token
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue" {
            let map =  (segue.destination as! NavigationController).viewControllers.first as! MapViewController
            map.friendSegue = self.friendsToDisplay
            map.user = User.init(u: self.user)
        }
    }

}





