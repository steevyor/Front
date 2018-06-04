

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var `switch`: UISwitch!
    
    var user: User = User.init()
    
    //var partage : Bool = true
    var timer :Timer? = nil
    var timer2 :Timer? = nil
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
        
        //self.displayFriendPosition(pos: CLLocationCoordinate2D(latitude: 11.12, longitude: 12.11), friendName: "Soso")
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(MapViewController.updatePosition), userInfo: nil,
                             repeats: true)
        self.timer2 = Timer.scheduledTimer(timeInterval: 30, target: self,selector: #selector(MapViewController.updateFriends), userInfo: nil,
                             repeats: true)
        self.displayFriends()

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if !annotation.isEqual(mapView.userLocation){
            //mapView.removeAnnotation(annotation)
            
            
            var a = CustomMKAnnotationView()
            a.title = annotation.title as! String
            
            var zoomRect = MKMapRectNull;
            mapView.setVisibleMapRect(zoomRect, animated: true)
            let images = [#imageLiteral(resourceName: "monster"), #imageLiteral(resourceName: "ami-7"), #imageLiteral(resourceName: "ami-4"), #imageLiteral(resourceName: "ami-2"), #imageLiteral(resourceName: "ami-10"), #imageLiteral(resourceName: "ami-16"), #imageLiteral(resourceName: "ami-19")]
            
            let randomNum:UInt32 = arc4random_uniform(UInt32(images.count))
            let someInt:Int = Int(randomNum)
            a.image = images[someInt]
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
                    
        }
        )
    }
    }
    
    //récupérer les amis et leurs positions
    func updateFriends()
    {
        print("MapViewController.updateFriends : ")

        let parameters = [
            "pseudo": "\(self.user.getPseudo())",
            "tokenKey": "\(self.user.getToken())"
            ] as [String : AnyObject]
        
        print("MapViewController.updateFriends : Removing friends")
        self.user.deleteAllContacts()
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/friends")!
        print("MapViewController.updateFriends : URL : \(url)")

        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("MapViewController.updateFriends : Statut : \(statut)")

                if let tab = response["friends"] as? [AnyObject] {
                    print("MapViewController.updateFriends :  Récupération des friends")

                    for i in 0..<tab.count {
                        var f: Friend = Friend.init()
                        if let amis = tab[i] as? [String: AnyObject] {
                            f.setPseudo(s: amis["pseudo"] as! String )
                            if let coord = amis["coordinate"] as? [String: AnyObject] {
                                f.setCoordinates(latitude: coord["xCoordinate"] as! Double, longitude: coord["yCoordinate"] as! Double)
                            }
                        }
                        self.user.addContact(f: f)
                    }
                    //print("MapViewController.updateFriends : friends : \(self.friendsToDisplay)")
                }
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
    
    func displayFriendPosition(friend: Friend)
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = friend.getCoordinates()
        annotation.title = friend.getPseudo()

        let to = CLLocation(latitude: friend.getCoordinates().latitude, longitude: friend.getCoordinates().longitude)
        let from = CLLocation(latitude: self.user.getCoordinates().latitude, longitude: self.user.getCoordinates().longitude)
        let formatedString = String(format:"%.2f",Float(to.distance(from: from) / 1000.0 + 0.005))
        annotation.subtitle = "\(annotation.title!) est à \(formatedString) kilomètres"

        self.map.addAnnotation(annotation)
    }
    
    func displayFriends(){
            for i in 0..<self.user.getContacts().getList().count{
                displayFriendPosition(friend: self.user.getContacts().getList()[i])
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
        print("MapViewController.prepare ")

        if segue.identifier == "SegueFriends" {
            
            let barViewControllers = segue.destination as! UITabBarController
            let vueAmis = barViewControllers.viewControllers![0] as! VueAmisController
            vueAmis.user.addContacts(f: self.user.getContacts())
            vueAmis.user = User.init(u: self.user)
            let vueInvitations = barViewControllers.viewControllers![1] as! VueInvitationsController
            vueInvitations.user = User.init(u: self.user)
            let vueSuggestions = barViewControllers.viewControllers![2] as! SuggestionsController
            vueSuggestions.user = User.init(u: self.user)

            
        }
        
    }
    
    
    
    
    @IBAction func logOut(_ sender: Any) {

        print("MapViewController.disconnect : ")
        
        let parameters = [
            "userPseudo": "\(self.user.getPseudo())",
            "tokenKey": "\(self.user.getToken())"
            ] as [String : AnyObject]
        
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/disconnect")!
        print("MapViewController.disconnect : URL : \(url)")
        
        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("MapViewController.disconnect : Statut : \(statut)")
                if statut == 202 {
                    DispatchQueue.main.async(execute: {
                        let disconect = UserDefaults.standard
                        disconect.removeObject(forKey: "taken")
                        disconect.removeObject(forKey: "Bruce")
                        print("\(disconect.string(forKey: "taken"))")
                        print("\(disconect.string(forKey: "Bruce"))")
                        disconect.synchronize()
                        self.timer?.invalidate()
                        self.timer2?.invalidate()
                        print("ok")
                        self.performSegue(withIdentifier: "MapToLogin", sender: self)


                    })

                    
                }
                
        }
        )
        
      //Deconnexion
    }

    //Chargée d'afficher les messages à l'utilisateur
    func message(display: String, emoji: String, dissmiss: String) -> Void
    {
        let monAlerte = UIAlertController(title: emoji, message:display, preferredStyle: UIAlertControllerStyle.alert)
        monAlerte.addAction(UIAlertAction(title: dissmiss, style: UIAlertActionStyle.default,handler: nil))
        self.present(monAlerte, animated: true, completion: nil)
        
    }
    
}

