
import UIKit
import SwiftKeychainWrapper

class InscriptionPageController: UIViewController {
    
    @IBOutlet weak var loginPage: UIImageView!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    var msg: String = ""
    var emoji: String = ""
    
    
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
        let login = self.login.text
        let email = self.email.text
        let password1 = self.password1.text
        let password2 = self.password2.text
        
        print("bouton d'inscription")
        /* criteres pour une inscription reussie:
         remplir tous les champs
         les deux mots de passe sont différents
         email et login n'existent pas déjà
         mot de passe assez long ? */
        
        if (login?.isEmpty)! || (email?.isEmpty)! || (password1?.isEmpty)! || (password2?.isEmpty)!
        {
            let monAlerte = UIAlertController(title: "☔️", message:"Veuillez renseigner tous les champs", preferredStyle: UIAlertControllerStyle.alert)
            monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
            self.present(monAlerte, animated: true, completion: nil)
            
        }
        else
        {
        if password1 != password2 {
            let monAlerte = UIAlertController(title: "☔️", message:"Les mots de passe entrés sont différents", preferredStyle: UIAlertControllerStyle.alert)
            monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
            self.present(monAlerte, animated: true, completion: nil)
        
        }else{
            if ( password1?.range(of: "@") == nil && password2?.range(of: "@") == nil && password1?.range(of: ".") == nil && password2?.range(of: ".") == nil){
                let monAlerte = UIAlertController(title: "☔️", message:"Veuillez entrer un mail valide", preferredStyle: UIAlertControllerStyle.alert)
                monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                self.present(monAlerte, animated: true, completion: nil)
            
            } else {
                
                inscription(login: login!, email: email!, password1: password1!,
                            sortie:{statut in
                                print(statut)
                                if statut == 200 {
                                    self.msg = "L'inscription a bien été prise en compte, vous pouvez vous connecter !"
                                    self.emoji = "☀️"
                                    DispatchQueue.main.async(execute: {
                                        let monAlerte = UIAlertController(title: self.emoji, message:self.msg , preferredStyle: UIAlertControllerStyle.alert)
                                        monAlerte.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                                        self.present(monAlerte, animated: true, completion: nil)
                                    })
                                } else if statut == 403 {
                                    self.msg = "Pseudo déjà utilisé, veuillez en entrer un nouveau"
                                    self.emoji = "☔️"
                                    DispatchQueue.main.async(execute: {
                                        let monAlerte = UIAlertController(title: self.emoji, message:self.msg , preferredStyle: UIAlertControllerStyle.alert)
                                        monAlerte.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                                        self.present(monAlerte, animated: true, completion: nil)
                                    })
                                } else {
                                    self.msg = "Une erreur s'est produite, veuillez réessayer"
                                    self.emoji = "☔️"
                                    DispatchQueue.main.async(execute: {
                                        let monAlerte = UIAlertController(title: self.emoji, message:self.msg , preferredStyle: UIAlertControllerStyle.alert)
                                        monAlerte.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                                        self.present(monAlerte, animated: true, completion: nil)
                                    })
                                }
                            }
                            )
                
            }
        }
        
       
        }
    }
    
    
    func inscription( login: String, email: String, password1: String, sortie: @escaping (_ statut: Int) -> Void) {
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let parameters =
        [
            "pseudo": "\(login)",
            "email": "\(email)",
            "password": "\(password1)"
        ]
        
        let url = URL(string: "https://6adff20d.ngrok.io/api/user/inscription")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
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
            
            if let httpStatus = response as? HTTPURLResponse{
                print(httpStatus.statusCode)
                sortie(httpStatus.statusCode)
            }
            
            
        })
        task.resume()
        
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false

         
    }

    
    func okHandler(alert: UIAlertAction!)
    {
        self.navigationController?.pushViewController(UIViewController(), animated: true)
    }
    
 }
