
import UIKit
import SwiftKeychainWrapper

class InscriptionPageController: UIViewController {
    
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
    
    @IBAction func inscription(_ sender: UIButton){
        inscription(login: login.text!, email: email.text!, password1: password1.text!, password2: password2.text!)
    }
    
    /*@IBAction func inscription(_ sender: UIButton)
    {
        
        print("bouton d'inscription")
        /* criteres pour une inscription reussie:
            remplir tous les champs
            les deux mots de passe sont différents
            email et login n'existent pas déjà
            mot de passe assez long ? */
 
        if (login.text?.isEmpty)! || (email.text?.isEmpty)! || (password1.text?.isEmpty)! || (password2.text?.isEmpty)!
        {
            let monAlerte = UIAlertController(title: "☔️", message:"Veuillez renseigner tous les champs", preferredStyle: UIAlertControllerStyle.alert)
            monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(monAlerte, animated: true, completion: nil)
            
        }
        else
        {
            if password1.text == password2.text
            {
                let monAlerte = UIAlertController(title: "☀️", message:
                "L'inscription a bien été prise en compte, vous pouvez vous connecter !", preferredStyle: UIAlertControllerStyle.alert)
                monAlerte.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(monAlerte, animated: true, completion: nil)

                return
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
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
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                loading.stopAnimating()
                
                
                
            }
            else
            {
                //alert()
                //alert.createAlert(msg: "l'inscription à échoué, mots de passe différents")
                let monAlerte = UIAlertController(title: "☔️", message:
                    "Attention les mots de passes entrés sont différents !", preferredStyle: UIAlertControllerStyle.alert)
                monAlerte.addAction(UIAlertAction(title: "Annuler", style: .default,handler: nil ))
                self.present(monAlerte, animated: true, completion: nil)
            }
            
            
        }

        
    }
    */
    
    func inscription( login: String, email: String, password1: String, password2: String)
    {
        
        print("bouton d'inscription")
        /* criteres pour une inscription reussie:
         remplir tous les champs
         les deux mots de passe sont différents
         email et login n'existent pas déjà
         mot de passe assez long ? */
        
        if (login.isEmpty) || (email.isEmpty) || (password1.isEmpty) || (password2.isEmpty)
        {
            let monAlerte = UIAlertController(title: "☔️", message:"Veuillez renseigner tous les champs", preferredStyle: UIAlertControllerStyle.alert)
            monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(monAlerte, animated: true, completion: nil)
            
        }
        else
        {
            if password1 == password2
            {
                
                
                return
                    
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                
                let parameters =
                    [
                        "login": "\(login)",
                        "login": "\(email)",
                        "login": "\(password1)"
                ]
                
                let loading = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                
                loading.center = loginPage.center
                loading.hidesWhenStopped = false
                loading.startAnimating()
                loginPage.addSubview(loading)
                
                
                let url = URL(string: "163.172.154.4:8080/dant/api/test/register")!
                
                let session = URLSession.shared
                
                var request = URLRequest(url: url)
                request.httpMethod = "PUT" //set http method as POST
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
                        print(response!)
                        return
                    }
                    do {
                        print(response!)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                })
                task.resume()
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                loading.stopAnimating()
                
                let monAlerte = UIAlertController(title: "☀️", message:
                    "L'inscription a bien été prise en compte, vous pouvez vous connecter !", preferredStyle: UIAlertControllerStyle.alert)
                monAlerte.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(monAlerte, animated: true, completion: nil)
                
                
                
            }
            else
            {
                //alert()
                //alert.createAlert(msg: "l'inscription à échoué, mots de passe différents")
                let monAlerte = UIAlertController(title: "☔️", message:
                    "Attention les mots de passes entrés sont différents !", preferredStyle: UIAlertControllerStyle.alert)
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
