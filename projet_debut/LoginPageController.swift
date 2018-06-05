import UIKit
import SwiftKeychainWrapper
import MapKit

class LoginPageController: UIViewController, UITextFieldDelegate
{

    
    
    @IBOutlet weak var loginPage: UIImageView!
    @IBOutlet weak var pseudo: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    var user: User = User.init()    
    
    //Les amis récupérés à afficher sur la map
    //var friendsToDisplay = FriendList()
    
    
    override func viewDidLoad()
    {
        self.pseudo.delegate = self
        self.mdp.delegate = self
        let tab = [Friend.init(pseudo: "A", coord: CLLocationCoordinate2D(latitude: 20.10, longitude: 10.12)),
             Friend.init(pseudo: "B", coord: CLLocationCoordinate2D(latitude: 83.10, longitude: 15.19)),
             Friend.init(pseudo: "C", coord: CLLocationCoordinate2D(latitude: 04.15, longitude: 17.11))]
        
        self.user.addContacts(f: FriendList(f: tab))
        super.viewDidLoad()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.pseudo.resignFirstResponder()
        self.mdp.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
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
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let r = Requests()
            r.connexion(login: login!, password: password!, messages: {
                user, message in
                DispatchQueue.main.async(execute: {
                    print("LoginController.connexion")
                    self.user = User.init(u: user)
                    print(self.user.getPseudo(), self.user.getToken())
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if message != "" {
                        self.message(display: message, emoji: "☔️", dissmiss: "Annuler")
                    } else {
                        DispatchQueue.main.async(execute: {
                            let connect = UserDefaults.standard
                            connect.set(self.user.getPseudo(), forKey: "Bruce")
                            connect.set(self.user.getToken(), forKey: "taken")
                            connect.synchronize()
                            self.performSegue(withIdentifier: "SegueLogin", sender: nil)
                        })

                    }
                    
                })
            })

        }
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
            map.user = User.init(u: self.user)

        }
    }

}





