

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var `switch`: UISwitch!
    
    //Amis récupérés à afficher
    var friendsToDisplay: FriendList = FriendList.init()
    var friendSegue: [Friend] = [Friend].init()
    
    var user: User = User.init()
    
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
        
        map.delegate = self
        
        self.zoomPos()
        self.displayFriendPosition(pos: CLLocationCoordinate2D(latitude: 11.12, longitude: 12.11), friendName: "Soso")
        print(self.del.locations.longitude, del.locations.latitude)
        
        Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(MapViewController.updatePosition), userInfo: nil,
                             repeats: true)
        //Ajouter à la liste d'amis à afficher
        friendsToDisplay.addList(tab: self.friendSegue)
        for i in 0...friendsToDisplay.list.count-1 {
            print("dans map", friendsToDisplay.getList()[i].getPseudo(), friendsToDisplay.getList()[i].getCoordinates().latitude, friendsToDisplay.getList()[i].getCoordinates().longitude )
        }
        self.displayFriends()
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let animals: [UIImage] = [#imageLiteral(resourceName: "alligator"), #imageLiteral(resourceName: "bear"), #imageLiteral(resourceName: "bird"), #imageLiteral(resourceName: "bull"), #imageLiteral(resourceName: "chicken"), #imageLiteral(resourceName: "clown-fish"), #imageLiteral(resourceName: "dinosaur"), #imageLiteral(resourceName: "dolphin"), #imageLiteral(resourceName: "duck"), #imageLiteral(resourceName: "deer"), #imageLiteral(resourceName: "falson"), #imageLiteral(resourceName: "fish"), #imageLiteral(resourceName: "giraffe"), #imageLiteral(resourceName: "gorilla"), #imageLiteral(resourceName: "hummingbird"), #imageLiteral(resourceName: "leopard"), #imageLiteral(resourceName: "octopus"), #imageLiteral(resourceName: "pelican"), #imageLiteral(resourceName: "pig"), #imageLiteral(resourceName: "puffin"), #imageLiteral(resourceName: "running-rabbit"), #imageLiteral(resourceName: "seahorse"), #imageLiteral(resourceName: "sheep"), #imageLiteral(resourceName: "stork"), #imageLiteral(resourceName: "turtle"), #imageLiteral(resourceName: "unicorn")]
        let index: Int = Int(arc4random_uniform(UInt32(animals.count-1)))

        
        if !annotation.isEqual(mapView.userLocation){
            //mapView.removeAnnotation(annotation)
            //var a = mapView.dequeueReusableAnnotationView(withIdentifier: "friend")
            //let a = CustomMKAnnotationView(annotation: annotation, "friend")
            var a = CustomMKAnnotationView()
            print("dans display", annotation.title, annotation.coordinate.latitude, annotation.coordinate.longitude )
            a.title = annotation.title as! String
            
            var zoomRect = MKMapRectNull;
            mapView.setVisibleMapRect(zoomRect, animated: true)
            
            
            
            a.image = animals[index]
            a.annotation = annotation
            a.canShowCallout = true
            a.calloutOffset = CGPoint(x: -5, y: 5)
            
            //let detailButton = UIButton(type: .detailDisclosure) as UIView
            //a.rightCalloutAccessoryView = detailButton
            return a
        }
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        updatePosition()
    }

    //envoyer notre position au server
    func updatePosition()
    {//Code ici
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        /*
        let parameters = [
            "pseudo": "\(self.user.getPseudo())",
            "tokenKey": "\(self.user.getToken())",
            "xCoordin"
            ] as [String : AnyObject]
        
        let url = URL(string: "https://9b638f40.ngrok.io/api/user/updateUserCoordinates")!
        
        
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
        )*/

        
    
    }
    
    //récupérer les amis et leurs positions
    func updateFriends()
    {
                   
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
        }
            else
        {
            self.del.disableLocationManager()
            self.partage = false
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
            vueAmis.user = User.init(u: self.user)
            
        }
       
        
    }
    
    
    
    @IBAction func logOut(_ sender: Any) {
        
      //Deconnexion
    }

    @IBAction func liste(_ sender: Any) {
        //charger la liste d'amis
        
        
        
    }
}

