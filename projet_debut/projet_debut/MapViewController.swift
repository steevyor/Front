

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var `switch`: UISwitch!
    
    //Amis récupérés à afficher
    var friendsToDisplay: FriendList = FriendList.init()
    var friendSegue: [Friend] = [Friend].init()
    
    var token: String = ""
    
    var partage : Bool = true
    let timer :Timer? = nil
    deinit
    {
        if let timer = self.timer
        {
            timer.invalidate()
        }
    }
    
    let del = UIApplication.shared.delegate as! MappAppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.zoomPos()
        self.displayFriendPosition(pos: CLLocationCoordinate2D(latitude: 11.12, longitude: 12.11), friendName: "Soso")
        print(self.del.locations.longitude, del.locations.latitude)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(MapViewController.updatePosition), userInfo: nil,
                             repeats: true)
        //Ajouter à la liste d'amis à afficher
        friendsToDisplay.addList(tab: self.friendSegue)
        self.displayFriends()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        updatePosition()
    }

    //envoyer notre position au server
    func updatePosition()
    {
        if self.partage
        {
            let latitude = del.locations.latitude
            let longitude = del.locations.longitude
            
            print("Longitude :\(longitude) , Latitude: \(latitude)")
            
            let parameters = [
                "latitude": "Longitude \(longitude)",
                "longitude": "Latitude \(latitude)",
            ]
            
            let feedURL = "163.172.154.4:8080/dant/api/test/position"
            
            var request = URLRequest(url: URL(string: feedURL)!)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else
            {
                print("Something append")
                return
            }
            request.httpBody = httpBody
            _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            }.resume()
            
        }
            else
        {
            return
        }
    
    }
    
    //récupérer les amis et lerus positions
    func updateFriends()
    {
            /*
            let feedURL = "163.172.154.4:8080/dant/api/test/position"    // verifier adresse
            
            var request = URLRequest(url: URL(string: feedURL)!)
            request.httpMethod = "GET"
            //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
                //chaque ligne du JSon se décompose en login, longitude, latitude
                let login = feed.value(forKeyPath: "feed.entry.im:login.label") as? String ,
                let longitude = feed.value(forKeyPath: "feed.entry.im:longitude.label") as? String ,
                let latitude = feed.value(forKeyPath: "feed.entry.im:latitude.label") as? String {
                    
                    var f: Friend = Friend.init(pseudo: login)
                    f.setCoordinates(latitude: longitude, longitude: latitude)
                    
                }
            
            
            
            
            
            
                //let imageURLs = feed.value(forKeyPath: "feed.entry.im:image") as? [NSDictionary] {
                //if let imageURL = imageURLs.last ,
                /*let imageURLString = imageURL.value(forKeyPath: "label") as? String{
                self.loadImage(from: URL(string:imageURLString)!)
                self.titleLabel.text = title*/
 
 
 
                }.resume()*/
        
        
        let feedURL = "163.172.154.4:8080/dant/api/test/position"    // verifier adresse
        var request = URLRequest(url: URL(string: feedURL)!)
        let session = URLSession.shared.dataTask(with: request ,completionHandler:
        { (data, response, error) in
            if let jsonData = data ,
                let feed = (try? JSONSerialization.jsonObject(with: jsonData , options: .mutableContainers)) as? NSDictionary ,
                let login = feed.value(forKeyPath: "feed.entry.im:login.label") as? String ,
                let longitude = feed.value(forKeyPath: "feed.entry.im:longitude.label") as? String ,
                let latitude = feed.value(forKeyPath: "feed.entry.im:latitude.label") as? String {
                var f: Friend = Friend.init(pseudo: login)
                f.setCoordinates(latitude: longitude as! CLLocationDegrees, longitude: latitude as! CLLocationDegrees)
            }
        })
        
        //créer un tableau de friends pour l'afficher
        session.resume()
        
        
    }


    @IBAction func switchButtonChanged (sender: UISwitch)
    {
        /*if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION/your.bundle.identifier") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }*/
        
        if sender.isOn
        {
            self.del.enableLocationManager()
            self.partage = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
            else
        {
            self.del.disableLocationManager()
            self.partage = false
             UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    @IBAction func loupe(_ sender: UIButton)
    {
        self.zoomPos()        
    }
    
    func displayFriendPosition(pos: CLLocationCoordinate2D, friendName: String)
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pos
        annotation.title = friendName
        //annotation.UIImage(named: "pins.png")
        self.map.addAnnotation(annotation)
    }
    
    func displayFriends(){
        if self.friendsToDisplay.getList().count != 0 {
            for i in 0...self.friendsToDisplay.getList().count-1{
                displayFriendPosition(pos: self.friendsToDisplay.getList()[i].getCoordinates(), friendName:
                    self.friendsToDisplay.getList()[i].getPseudo())
            }
        }
        
    }
    
    func zoomPos()
    {
        self.map.setUserTrackingMode( MKUserTrackingMode.followWithHeading, animated: true) //zoomer sur la position
    }
    
    func myPos()-> CLLocationCoordinate2D {
        return self.del.locations
    }
    
    //Envoyer à la vue suivante les amis récupérés et le token

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue" {
            let tab = [Friend.init(pseudo: "A"), Friend.init(pseudo: "B"), Friend.init(pseudo: "C")]
            let vueAmis = (segue.destination as! TabBarController).viewControllers?.first as! VueAmisController
            vueAmis.friendSegue = tab
            vueAmis.token = self.token
        }
       
        
    }
    
    
    
    @IBAction func logOut(_ sender: Any) {
        
      //Deconnexion
    }

    @IBAction func liste(_ sender: Any) {
        //charger la liste d'amis
        
        
        
    }
}

