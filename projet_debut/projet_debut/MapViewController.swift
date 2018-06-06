

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var `switch`: UISwitch!
    
    var user: User = User.init()
    
    //var partage : Bool = true
    var timer :Timer? = nil
    var timer2 :Timer? = nil
    var timer3 :Timer? = nil

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
        
        //Mettre à jour la position du user et récupérer celles des amis toutes les 5 sec
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(MapViewController.updatePosition), userInfo: nil,
                             repeats: true)
        self.timer2 = Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(MapViewController.updateFriends), userInfo: nil,
                             repeats: true)
        
        //Créer les annotations pour chaque ami affiché
        self.displayFriends()

    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if !annotation.isEqual(mapView.userLocation){
            
            //Ne pas changer l'annotation du user
            if !(annotation is MKPointAnnotation) {
                return nil
            }
            
            //Récupérer l'ami en fonction de son pseudo dans le tableau d'amis du user
            let f = Friend.init(f: self.user.getContacts().find(pseudo: annotation.title as! String))
            
            //Soit réutiliser l'annotationview soit en créer une en fonction de l'annotationpoint pour changer son image
            let annotationIdentifier = "ami"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                
            }
            else {
                annotationView!.annotation = annotation
            }
            
            annotationView?.image = UIImage(named: f.getImage())
            annotationView!.canShowCallout = true
            
            let detailButton = UIButton(type: .detailDisclosure) as UIView
            annotationView?.rightCalloutAccessoryView = detailButton
            
            return annotationView

        }
        return nil
    }

 
    override func viewWillAppear(_ animated: Bool)
    {
        //Charger les amis quand l'itel est selectionné
        updatePosition()
    }

    //envoyer la position du user au server si celui ci la partage
    func updatePosition(){
        if self.user.getIsVIsible() == true {

            self.user.setCoord(c: CLLocationCoordinate2D(latitude: self.del.locations.latitude, longitude: self.del.locations.longitude))
            let r = Requests()
            r.refreshPosition(user: self.user)
        }
    
    }
    
    
    //récupérer les amis et leurs positions
    func updateFriends()
    {
        print("MapViewController.updateFriends : ")
        //paramètres à envoyer au server
        let parameters = [
            "pseudo": "\(self.user.getPseudo())",
            "tokenKey": "\(self.user.getToken())"
            ] as [String : AnyObject]
        
        //REtirer l'ancienne liste d'amis
        print("MapViewController.updateFriends : Removing friends")
        self.user.deleteAllContacts()
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/friends")!
        print("MapViewController.updateFriends : URL : \(url)")

        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("MapViewController.updateFriends : Statut : \(statut)")

                //Si'il y a une liste de friends
                if let tab = response["friends"] as? [AnyObject] {
                    print("MapViewController.updateFriends :  Récupération des friends")

                    for i in 0..<tab.count {
                        //Créer un friend vide...
                        var f: Friend = Friend.init()
                        if let amis = tab[i] as? [String: AnyObject] {
                            //... et ajouter les pseudo, tokens, images
                            f.setPseudo(s: amis["pseudo"] as! String )
                            if let coord = amis["coordinate"] as? [String: AnyObject] {
                                f.setCoordinates(latitude: coord["xCoordinate"] as! Double, longitude: coord["yCoordinate"] as! Double)
                            }
                            if let image = amis["image"] as? String {
                                f.setImage(s: image)
                            }
                        }
                        //ajouté cet ami à la liste des mais du user
                        self.user.addContact(f: f)
                    }
                    DispatchQueue.main.async(execute: {
                        //Créer tous les points à afficher
                        self.displayFriends()
                    })
                }
        }
        )
        
        
        
    }

    //Pour ne pas partager la position du user
    @IBAction func switchButtonChanged (sender: UISwitch)
    {
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
    
    //Zoomer sur la position actuelle du user
    @IBAction func loupe(_ sender: UIButton)
    {
        self.zoomPos()        
    }
    
    
    func zoomPos()
    {
        self.map.setUserTrackingMode( MKUserTrackingMode.followWithHeading, animated: true) //zoomer sur la position
    }
    
    //Créer des annotations pour un ami
    func displayFriendPosition(friend: Friend)
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = friend.getCoordinates()
        annotation.title = friend.getPseudo()
        
        let to = CLLocation(latitude: friend.getCoordinates().latitude, longitude: friend.getCoordinates().longitude)
        let from = CLLocation(latitude: self.del.locations.latitude, longitude: self.del.locations.longitude)
        let formatedString = String(format:"%.2f",Float(from.distance(from: to) / 1000.0 + 0.005))
        
        annotation.subtitle = "\(friend.getPseudo()) est à \(formatedString) kilomètres"
        
        self.map.addAnnotation(annotation)
    }
    
    //Créer les annotatinos pour tous les mais de la liste
    func displayFriends(){
        map.removeAnnotations(map.annotations)
        
        for i in 0..<self.user.getContacts().getList().count{
            displayFriendPosition(friend: self.user.getContacts().getList()[i])
        }
        
    }
    
    
    func myPos()-> CLLocationCoordinate2D {
        return self.del.locations
    }
    
    //Envoyer à la vue suivante le user comprenant le pseudo, le token, les listes d'amis
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("MapViewController.prepare ")

        if segue.identifier == "SegueFriends" {

            let barViewControllers = segue.destination as! UITabBarController
            
            let vueAmis = barViewControllers.viewControllers![0] as! VueAmisController
            vueAmis.user = User.init(u: self.user)
            
            let vueInvitations = barViewControllers.viewControllers![1] as! VueInvitationsController
            vueInvitations.user = User.init(u: self.user)
            
            let vueSuggestions = barViewControllers.viewControllers![2] as! SuggestionsController
            vueSuggestions.user = User.init(u: self.user)

        }
        
    }
    
    //Déconnecter un user
    @IBAction func logOut(_ sender: Any) {
        let r = Requests()
        r.logOut(user: self.user, timer: self.timer!, timer2: self.timer2!)
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "MapToLogin", sender: self)
        })
        
        }

    //Chargée d'afficher les messages à l'utilisateur
    func message(display: String, emoji: String, dissmiss: String) -> Void
    {
        let monAlerte = UIAlertController(title: emoji, message:display, preferredStyle: UIAlertControllerStyle.alert)
        monAlerte.addAction(UIAlertAction(title: dissmiss, style: UIAlertActionStyle.default,handler: nil))
        self.present(monAlerte, animated: true, completion: nil)
        
    }
    
}

