

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var `switch`: UISwitch!
    
    //Amis à afficher
    var friendsToDisplay: FriendList = FriendList.init()
    //Amis récupérés
    var friendSegue: [Friend] = [Friend].init()
    
    var user: User = User.init()
    
    //var partage : Bool = true
    let timer :Timer? = nil
    let del = UIApplication.shared.delegate as! MappAppDelegate
    
    deinit
    {
        if let timer = self.timer
        {
            timer.invalidate()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        map.delegate = self
        
        self.zoomPos()
        
        self.displayFriendPosition(pos: CLLocationCoordinate2D(latitude: 11.12, longitude: 12.11), friendName: "Soso")
        
        Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(MapViewController.updatePosition), userInfo: nil,
                             repeats: true)
        Timer.scheduledTimer(timeInterval: 30, target: self,selector: #selector(MapViewController.updateFriends), userInfo: nil,
                             repeats: true)
        
        //Ajouter la liste récupérée a la FriendListe à afficher
        friendsToDisplay.addList(tab: self.friendSegue)
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
    {
        if self.user.getIsVIsible() == true {
            print("MapViewController.updatePosition : Coordinates : \(self.del.locations.latitude) , \(self.del.locations.longitude)")

            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
            let parameters = [
                "pseudo": "\(self.user.getPseudo())",
                "tokenKey": "\(self.user.getToken())",
                "xCoordinates": "\(self.del.locations.longitude)",
                "yCoordinates": "\(self.del.locations.latitude)"
                ] as [String : AnyObject]
        
            let url = URL(string: "https://\(ngrok).ngrok.io/api/user/updateUserCoordinates")!
            print("MapViewController.updatePosition : URL : \(url)")

        
            let r = Requests()
            r.post(parameters: parameters, url: url,
                finRequete:{ response, statut in
                    print("MapViewController.updatePosition : Statut : \(statut) ")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        )
    }
    }
    
    //récupérer les amis et leurs positions
    func updateFriends()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("MapViewController.updateFriends : ")

        let parameters = [
            "pseudo": "\(self.user.getPseudo())",
            "tokenKey": "\(self.user.getToken())"
            ] as [String : AnyObject]
        
        print("MapViewController.updateFriends : Removing friends")
        self.friendsToDisplay.remove()
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/friends")!
        print("MapViewController.updateFriends : URL : \(url)")

        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("MapViewController.updateFriends : Statut : \(statut)")

                if let tab = response["friends"] as? [AnyObject] {
                    print("MapViewController.updateFriends :  Récupération des friends")

                    for i in 0...tab.count-1 {
                        var f: Friend = Friend.init()
                        if let amis = tab[i] as? [String: AnyObject] {
                            f.setPseudo(s: amis["pseudo"] as! String )
                            if let coord = amis["coordinate"] as? [String: AnyObject] {
                                f.setCoordinates(latitude: coord["xCoordinate"] as! Double, longitude: coord["yCoordinate"] as! Double)
                            }
                        }
                        self.friendsToDisplay.addFriend(f: f)
                    }
                    //print("MapViewController.updateFriends : friends : \(self.friendsToDisplay)")
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        )
        
        
        
    }


    @IBAction func switchButtonChanged (sender: UISwitch)
    {
        /*if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION/your.bundle.identifier") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }*/
        
        if sender.isOn
        {
            self.del.enableLocationManager()
            self.user.setIsVIsible(b: true)
        }
            else
        {
            self.del.disableLocationManager()
            self.user.setIsVIsible(b: false)
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

