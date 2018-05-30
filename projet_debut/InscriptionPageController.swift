
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
        /*
         criteres pour une inscription reussie: remplir tous les champs
         les deux mots de passe sont différents
         email et login n'existent pas déjà
         mot de passe assez long ?
         */
        
        if (login?.isEmpty)! || (email?.isEmpty)! || (password1?.isEmpty)! || (password2?.isEmpty)!
        {
            self.message(display: "Veuillez renseigner tous les champs", emoji: "☔️", dissmiss: "Annuler")
            
        }
        else
        {
            if password1 != password2 {
                    self.message(display: "Les mots de passe entrés sont différents", emoji: "☔️", dissmiss: "Annuler")
                
            }else{
                if !isValidEmailAddress(emailAddressString: email!) {
                    self.message(display: "Veuillez entrer un mail valide", emoji: "☔️", dissmiss: "Annuler")
                    
                    
                } else {
                    
                    inscription(login: login!, email: email!, password1: password1!,
                                sortie:{statut in
                                    print(statut)
                                    if statut == 200 {
                                        self.msg = "L'inscription a bien été prise en compte, vous pouvez vous connecter !"
                                        self.emoji = "☀️"
                                        DispatchQueue.main.async(execute: {
                                            self.message(display: self.msg, emoji: self.emoji, dissmiss: "Ok")
                                        })
                                    } else if statut == 403 {
                                        self.msg = "Pseudo déjà utilisé, veuillez en entrer un nouveau"
                                        self.emoji = "☔️"
                                        DispatchQueue.main.async(execute: {
                                            self.message(display: self.msg, emoji: self.emoji, dissmiss: "Ok")
                                        })
                                    } else {
                                        self.msg = "Une erreur s'est produite, veuillez réessayer"
                                        self.emoji = "☔️"
                                        DispatchQueue.main.async(execute: {
                                            self.message(display: self.msg, emoji: self.emoji, dissmiss: "Ok")
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
    // Vérification de la validité du mail
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@([A-Za-z0-9.-]{3,})+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func okHandler(alert: UIAlertAction!)
    {
        self.navigationController?.pushViewController(UIViewController(), animated: true)
    }
    
    func message(display: String, emoji: String, dissmiss: String) -> Void {
        let monAlerte = UIAlertController(title: emoji, message:display, preferredStyle: UIAlertControllerStyle.alert)
        monAlerte.addAction(UIAlertAction(title: dissmiss, style: UIAlertActionStyle.default,handler: nil))
        self.present(monAlerte, animated: true, completion: nil)
        
    }
    
    
}
