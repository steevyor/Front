import UIKit
import Alamofire
import SwiftKeychainWrapper

class InscriptionPage: UIViewController {
    
    @IBOutlet weak var loginPage: UIImageView!
    
    @IBOutlet weak var login: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password1: UITextField!
    
    @IBOutlet weak var password2: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inscription(_ sender: UIButton)
    {
        
        print("bouton d'inscription")
        /* criteres pour une inscription reussie:
            remplir tous les champs
            les deux mots de passe sont différents
            email et login n'existent pas déjà
            mot de passe assez long ? */
 
        if (login.text?.isEmpty)! || (email.text?.isEmpty)! || (password1.text?.isEmpty)! || (password2.text?.isEmpty)!
        {
            let monAlerte = UIAlertController(title: "☔️", message:
                "Veuillez renseigner tout les champs", preferredStyle: UIAlertControllerStyle.alert)
            monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(monAlerte, animated: true, completion: nil)
            
        }
        else
        {
            if password1.text == password2.text
            {
                //Alert.alert()
                //alert.createAlert(msg: "inscription effectuée vous pouvez maintenant vous connecter")
                return
                
                let parameters =
                    [
                    "login": "\(login.text!)",
                    "login": "\(email.text!)",
                    "login": "\(password1.text!)"
                    ]
                
                let loading = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                
                loading.center = loginPage.center
                loading.hidesWhenStopped = false
                loading.startAnimating()
                loginPage.addSubview(loading)
                
                let feedURL = "163.172.154.4:8080/dant/api/test/register"
                var request = URLRequest(url: URL(string: feedURL)!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
                request.httpBody = httpBody
                _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let jsonData = data{
                        print(data!)
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
                
                loading.stopAnimating()
                
                let monAlerte = UIAlertController(title: "", message:
                    "L'inscription a bien été prise en compte!", preferredStyle: UIAlertControllerStyle.alert)
                monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(monAlerte, animated: true, completion: nil)
                
                
            }
            else
            {
                //alert()
                //alert.createAlert(msg: "l'inscription à échoué, mots de passe différents")
                let monAlerte = UIAlertController(title: "Erreur", message:
                    "Attention les mots de passes entrés sont différents!", preferredStyle: UIAlertControllerStyle.alert)
                monAlerte.addAction(UIAlertAction(title: "Annuler", style: .default,handler: nil ))
                self.present(monAlerte, animated: true, completion: nil)
            }
            
            
        }

        
    }
    
    func okHandler(alert: UIAlertAction!)
    {
        self.navigationController?.pushViewController(UIViewController(), animated: true)
    }
    
}
