
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
        let login = self.login.text
        let email = self.email.text
        let password1 = self.password1.text
        let password2 = self.password2.text
        
        
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
                    self.message(display: "Les mots de passe entrés sont différents", emoji: "☔️", dissmiss: "Ok")
                
            }else{
                if !isValidEmailAddress(emailAddressString: email!) {
                    self.message(display: "Veuillez entrer un mail valide", emoji: "☔️", dissmiss: "Ok")
                    
                    
                } else {
                    
                    inscription(login: login!, email: email!, password: password1!)
                    
                }
            }
            
            
        }
    }
    

    
    func inscription( login: String, email: String, password: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("InscriptionPageController.inscription :  ")
        let images = ["monster", "ami-7", "ami-4", "ami-2", "ami10", "ami-16", "ami-19"]
        
        let randomNum:UInt32 = arc4random_uniform(UInt32(images.count))
        let someInt:Int = Int(randomNum)

        let parameters =
            [
                "pseudo": "\(login)",
                "email": "\(email)",
                "password": "\(password)",
                "image":"\(images[someInt])"
        ] as [String : AnyObject]
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/inscription")!
        print("InscriptionPageController.inscription : url : \(url)")
        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("InscriptionPageController.inscription : statut = \(statut)")
                
                
                if statut == 200 {
                    DispatchQueue.main.async(execute: {
                        self.message(display:  "L'inscription a bien été prise en compte, vous pouvez vous connecter !", emoji: "☀️", dissmiss: "Ok")
                    })
                } else if statut == 403 {
                    DispatchQueue.main.async(execute: {
                        self.message(display: "Pseudo déjà utilisé, veuillez en entrer un nouveau", emoji: "☔️", dissmiss: "Ok")
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        self.message(display: "Une erreur s'est produite, veuillez réessayer", emoji: "☔️", dissmiss: "Ok")
                    })
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
        })

        
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
