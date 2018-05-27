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
                self.connexion(login: login! ,password: password!)
                self.getToken()
                self.getFriends()
        }
    }
    
    
    
    func connexion(login: String, password: String){
        
        let parameters = [
            "pseudo": "\(login)",
            "password": "\(password)"
        ]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let feedURL = "https://59c86c5d.ngrok.io/api/user/auth"
        var request = URLRequest(url: URL(string: feedURL)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch let error {
            print(error.localizedDescription)
        }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("ERROR")
            return
        }
        request.httpBody = httpBody
        print("*********************************")
        print("\(request)")
        _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let jsonData = data ,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData , options: .mutableContainers)) as? NSDictionary , let token = feed.value(forKeyPath: "feed.entry.im:token.label") as? String
            {
                
                let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: "myKey")
                print("\(saveSuccessful)")
            }
            //let artist = feed.value(forKeyPath: "feed.entry.im:artist.label") as? String ,
            //let imageURLs = feed.value(forKeyPath: "feed.entry.im:image") as? [NSDictionary] {
            //if let imageURL = imageURLs.last ,
            /*let imageURLString = imageURL.value(forKeyPath: "label") as? String{
             self.loadImage(from: URL(string:imageURLString)!)
             self.titleLabel.text = title
             self.titleLabel.isHidden = false
             self.arstistLabel.text = artist
             self.arstistLabel.isHidden = false
             */
            }.resume()
        //getFriends()
        //getToken()

        
    }
    
    func getToken(){
        let feedURL = "163.172.154.4:8080/dant/api/test/token"    // verifier adresse
        var request = URLRequest(url: URL(string: feedURL)!)
        let session = URLSession.shared.dataTask(with: request ,completionHandler:
        { (data, response, error) in
            if let jsonData = data ,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData , options: .mutableContainers)) as? NSDictionary ,
                let token = feed.value(forKeyPath: "feed.entry.im:toke,.label") as? String {
                self.token = token
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





